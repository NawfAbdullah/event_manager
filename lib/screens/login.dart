import 'dart:convert';
import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/UserModel.dart';
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
  bool isLoading = false;
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : const SizedBox(
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
                const SizedBox(
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
                    setState(() {
                      isLoading = true;
                    });
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
                      User user = await getUser();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventScreen(
                                role: user.role,
                              )));
                    } else {
                      setState(() {
                        isLoading = false;
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
