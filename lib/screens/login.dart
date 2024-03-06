import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  late String email;
  late String password;

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
          TextField(
            onChanged: (value) {
              email = value;
            },
            decoration: kInputdecoration.copyWith(hintText: 'username'),
          ),
          SizedBox(
            height: 48,
          ),
          TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: kInputdecoration.copyWith(hintText: 'Password'),
          ),
          const SizedBox(
            height: 12.0,
          ),
          SubmitButton(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EventScreen()));
            },
            innerText: "Log In",
          )
        ],
      ),
    );
  }
}
