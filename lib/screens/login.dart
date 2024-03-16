import 'dart:convert';
import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late String email;
  late String password;
  String? error = null;
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cres Days',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          error != null
              ? Text(
                  error ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              : SizedBox(
                  height: 10,
                ),
          TextField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            decoration: kInputdecoration.copyWith(hintText: 'username'),
          ),
          SizedBox(
            height: 48,
          ),
          TextField(
            obscureText: true,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            decoration: kInputdecoration.copyWith(hintText: 'Password'),
          ),
          const SizedBox(
            height: 12.0,
          ),
          SubmitButton(
            onTap: () async {
              // factory Cookie(String name, String value)
              print("$email:$password");
              final response = await post(
                Uri.parse(
                    'https://event-management-backend.up.railway.app/api/auth/log-in'),
                body: jsonEncode(
                  {
                    "email": email,
                    "password": password,
                  },
                ),
                headers: {"Content-Type": "application/json"},
              );
              final body = jsonDecode(response.body);
              if (response.statusCode == 200) {
                await storage.write(
                  key: 'sessionId',
                  value: body['session_token'],
                );
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EventScreen()));
              } else {
                setState(() {
                  error = body["err_msg"];
                });
              }
            },
            innerText: "Log In",
          )
        ],
      ),
    );
  }
}
