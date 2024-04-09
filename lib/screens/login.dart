import 'dart:convert';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3FCE9),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AutofillHints.countryName,
                      fontSize: 40,
                      color: Color(0xff92a95f),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // const Text(
                //   'there!',
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     fontSize: 40,
                //     color: Color.fromARGB(255, 135, 135, 135),
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                SvgPicture.asset(
                  'assets/images/sunlight.svg',
                  width: MediaQuery.of(context).size.width * 0.4,
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: kInputdecoration.copyWith(
                        hintText: '', labelText: 'username'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    decoration: kInputdecoration.copyWith(
                        hintText: '', labelText: 'Password'),
                  ),
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
                          builder: (context) =>
                              EventScreen(role: user.role, user: user)));
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
