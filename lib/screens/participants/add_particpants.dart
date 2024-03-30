import 'dart:convert';

import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/screens/participants/bulk_upload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddParticpantScreen extends StatefulWidget {
  AddParticpantScreen({
    super.key,
    required this.eventId,
    required this.subEventId,
  });
  String eventId;
  String subEventId;

  @override
  State<AddParticpantScreen> createState() => _AddParticpantScreenState();
}

class _AddParticpantScreenState extends State<AddParticpantScreen> {
  String email = '';
  String name = '';
  String contact = '';
  String college = '';
  String err = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    err,
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextField(
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                    decoration: kInputdecoration.copyWith(
                      hintText: '',
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) => setState(() {
                      name = value;
                    }),
                    decoration: kInputdecoration.copyWith(
                      hintText: '',
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) => setState(() {
                      contact = value;
                    }),
                    decoration: kInputdecoration.copyWith(
                      hintText: '',
                      labelText: 'Contact',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onChanged: (value) => setState(() {
                      college = value;
                    }),
                    decoration: kInputdecoration.copyWith(
                      hintText: '',
                      labelText: 'College',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SubmitButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final response = await post(
                            Uri.parse(
                                "https://event-management-backend.up.railway.app/api/participant/add"),
                            body: jsonEncode({
                              "event_id": widget.eventId,
                              "sub_event_id": widget.subEventId,
                              "name": name,
                              "email": email,
                              "contact_no": contact,
                              "college": college,
                            }),
                            headers: {
                              'content-type': 'application/json',
                              'admin-access-code':
                                  "044453c2-e45a-4c5d-91b5-c3c14a483d61"
                            });

                        print(response.body);
                        if (response.statusCode == 200) {
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                            err = response.body;
                          });
                        }
                      },
                      innerText: 'Add')
                ],
              ),
      )),
    );
  }
}
