import 'dart:convert';

import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String old_password = '';
  String new_password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Change Password'),
          Text(
            error ?? '',
            style: TextStyle(color: Colors.redAccent),
          ),
          TextField(
            decoration: kInputdecoration,
            onChanged: (value) {
              setState(() {
                old_password = value;
              });
            },
          ),
          TextField(
            decoration: kInputdecoration,
            onChanged: (value) {
              setState(() {
                new_password = value;
              });
            },
          ),
          SubmitButton(
            onTap: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              final id = await storage.read(key: 'sessionId');
              final response = await post(
                  Uri.parse(
                    'https://event-management-backend.up.railway.app/api/auth/change-password',
                  ),
                  body: jsonEncode({
                    'old_password': old_password,
                    'new_password': new_password
                  }),
                  headers: {
                    'session_token': id ?? '',
                    'content-type': 'application/json'
                  });
              if (response.statusCode == 200) {
                Navigator.pop(context);
              } else {
                setState(() {
                  error = response.body;
                });
              }
            },
            innerText: 'Submit',
          )
        ],
      ),
    );
  }
}
