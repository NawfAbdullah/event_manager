import 'dart:convert';

import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class CreateStudentCoordinator extends StatefulWidget {
  const CreateStudentCoordinator({super.key});

  @override
  State<CreateStudentCoordinator> createState() =>
      _CreateStudentCoordinatorState();
}

class _CreateStudentCoordinatorState extends State<CreateStudentCoordinator> {
  String email = '';
  String name = '';
  String error = '';
  String type = 'type';
  bool isLoading = false;
  bool isSuccess = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            !isSuccess ? 'Create User' : 'Created $name',
            style: kTitleText,
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            error,
            style: const TextStyle(color: Colors.redAccent),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            decoration:
                kInputdecoration.copyWith(hintText: '', labelText: 'name'),
          ),
          SizedBox(
            height: 6,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            decoration: kInputdecoration.copyWith(
              hintText: '',
              labelText: 'email',
            ),
          ),
          SizedBox(
            height: 6,
          ),
          DropdownMenu(
            width: MediaQuery.of(context).size.width,
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              hintStyle: TextStyle(color: Color(0xff92a95f)),
              labelStyle: TextStyle(color: Color(0xff92a95f)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffC5D99A), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff92a95f), width: 3.0),
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
            hintText: type,
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: 'studentcoordinator',
                label: 'student coordinator',
              ),
              DropdownMenuEntry(
                value: 'volunteer',
                label: 'volunteer',
              ),
            ],
            onSelected: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
          SizedBox(
            height: 6,
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SubmitButton(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    FlutterSecureStorage storage = FlutterSecureStorage();
                    String? x = await storage.read(key: 'department');
                    final response = await post(
                        Uri.parse(
                            'https://event-management-backend.up.railway.app/api/auth/create-user'),
                        body: jsonEncode({
                          "type":
                              type, // one of [studentcoordinator, volunteer, hod]
                          "email": email,
                          "name": name,
                          "password": "1234",
                          "department": x ?? ''
                        }),
                        headers: {
                          'admin-access-code':
                              '044453c2-e45a-4c5d-91b5-c3c14a483d61',
                          'content-type': 'application/json'
                        });
                    print(response.body);
                    if (response.statusCode == 200) {
                      setState(() {
                        isLoading = false;
                        isSuccess = true;
                        email = '';
                      });
                      name = '';
                    } else {
                      setState(() {
                        isLoading = false;
                        error = jsonDecode(response.body)['err_msg'] ?? '';
                      });
                    }
                  },
                  innerText: 'Create')
        ],
      ),
    );
  }
}

// {
//     "type": "volunteer", // one of [studentcoordinator, volunteer, hod, participant]
//     "email": "dejong@gmail.com",
//     "name": "De Jong",
//     "s": "https://images.pexels.com/photos/20732688/pexels-photo-20732688/free-photo-of-man-in-suit-standing-in-lake.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
//     "password": "12345678",
//     "department": "cse" // only required for type: hod
// }