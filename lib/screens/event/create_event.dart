import 'dart:convert';
import 'dart:io';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _controller = TextEditingController();
  File? _imgFile;
  String name = '';
  String department = 'Department';
  String start = '';
  String end = '';
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool isLoading = false;
  String error = '';
  void getPicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path); // convert it to a Dart:io file
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => getPicker(),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _imgFile != null
                          ? Image.file(
                              _imgFile!,
                              width: MediaQuery.of(context).size.width * 0.6,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 200,
                              color: const Color.fromARGB(255, 189, 255, 198),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/photo.png',
                                    width: 100,
                                  ),
                                  const Text(
                                    'Upload',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )),
                            )
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              error != null
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(
                      height: 5,
                    ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) => setState(() {
                  name = value;
                }),
                decoration: kInputdecoration.copyWith(
                    labelText: 'Event Name', hintText: ''),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu(
                width: MediaQuery.of(context).size.width,
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintStyle: TextStyle(color: Color(0xff92a95f)),
                  labelStyle: TextStyle(color: Color(0xff92a95f)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffC5D99A), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff92a95f), width: 3.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
                hintText: department,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'ece', label: 'ece'),
                  DropdownMenuEntry(value: 'cse', label: 'cse'),
                  DropdownMenuEntry(value: 'mech', label: 'mech'),
                  DropdownMenuEntry(value: 'biotech', label: 'biotech'),
                ],
                onSelected: (value) {
                  setState(() {
                    department = value!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _controller,
                decoration: kInputdecoration.copyWith(
                  prefixIcon: const Icon(Icons.calendar_month_rounded),
                  labelText: 'Select date',
                  hintText: '',
                ),
                onTap: _selectDate,
                readOnly: true,
              ),
              const SizedBox(
                height: 5,
              ),
              SubmitButton(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final id = await storage.read(key: "sessionId");
                  final bytes = File(_imgFile!.path).readAsBytesSync();
                  String img64 = base64Encode(bytes);
                  final response = await post(
                      Uri.parse(
                        "https://event-management-backend.up.railway.app/api/event/create",
                      ),
                      body: jsonEncode(start == end
                          ? {
                              "name": name,
                              "date_from": start,
                              "department": department,
                              "date_to": null,
                              "img": "data:image/png;base64," + img64,
                            }
                          : {
                              "name": name,
                              "date_from": start,
                              "date_to": end,
                              "department": department,
                              "img": "data:image/png;base64," + img64
                            }),
                      headers: {
                        "Content-Type": "application/json",
                        "session_token": id ?? ''
                      });
                  if (response.statusCode == 200) {
                    setState(() {
                      isLoading = false;
                    });
                    print(response.body);
                    final parsed = jsonDecode(response.body);
                    EventModel x = EventModel.fromJson(parsed);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Event(
                              eventModel: x,
                              role: 'studentcoordinator',
                            )));
                  } else {
                    print(response.body);
                    setState(() {
                      isLoading = false;
                      error = jsonDecode(response.body)['err_msg'];
                    });
                    throw Exception('Something went wrong');
                  }
                },
                innerText: "Add",
              ),
            ],
          );
  }

  Future<void> _selectDate() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        ),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        start =
            "${picked.start.year}-${picked.start.month}-${picked.start.day}";
        end = "${picked.end.year}-${picked.end.month}-${picked.end.day}";
        _controller.text =
            "${start.replaceAll('-', '/')} - ${end.replaceAll('-', '/')}";
      });
    }
  }
}
