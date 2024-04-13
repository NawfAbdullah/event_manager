import 'dart:convert';

import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChangeDetails extends StatefulWidget {
  const ChangeDetails({super.key, required this.sessionId, required this.user});
  final String sessionId;
  final User user;
  @override
  State<ChangeDetails> createState() => _ChangeDetailsState();
}

class _ChangeDetailsState extends State<ChangeDetails> {
  String name = '';
  String contact = '';
  String err = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/welcome.png',
              width: 300,
            ),
            Text(
              err,
              style: const TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              decoration:
                  kInputdecoration.copyWith(labelText: 'Name', hintText: ''),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              decoration:
                  kInputdecoration.copyWith(labelText: 'Contact', hintText: ''),
              onChanged: (value) {
                setState(() {
                  contact = value;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            SubmitButton(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final result = await patch(
                      Uri.parse(
                          "https://event-management-backend.up.railway.app/api/participant/change-name"),
                      body: jsonEncode({'name': name, 'contact_no': contact}),
                      headers: {
                        'content-type': 'application/json',
                        'session_token': widget.sessionId
                      });
                  print(result.body);
                  setState(() {
                    isLoading = false;
                  });
                  if (result.statusCode == 200) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EventScreen(
                          role: widget.user.role, user: widget.user),
                    ));
                  } else {
                    setState(() {
                      err = jsonDecode(result.body)['err_msg'];
                    });
                  }
                },
                innerText: 'Submit')
          ]),
        ),
      ),
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/welcome" title="welcome icons">Welcome icons created by Paul J. - Flaticon</a>