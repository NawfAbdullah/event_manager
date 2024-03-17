import 'dart:convert';

import 'package:event_manager/components/SubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class RequestPage extends StatefulWidget {
  RequestPage({
    super.key,
    required this.eventId,
    required this.subEventId,
  });
  final String eventId;
  final String subEventId;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String position = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "You don't have access",
            style: TextStyle(fontSize: 30),
          ),
          err.length > 0
              ? Text(
                  err,
                  style: TextStyle(color: Colors.redAccent),
                )
              : Text(''),
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            'assets/images/request.svg',
            height: 200,
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 'volunteer',
                  child: Text('volunteer'),
                ),
                DropdownMenuItem(
                  value: 'eventmanager',
                  child: Text('event manger'),
                )
              ],
              onChanged: (value) {
                setState(() {
                  position = value ?? '';
                });
              }),
          SizedBox(
            height: 20,
          ),
          SubmitButton(
              onTap: () async {
                FlutterSecureStorage storage = FlutterSecureStorage();
                final id = await storage.read(key: 'sessionId');
                final response = await post(
                    Uri.parse(
                        "https://event-management-backend.up.railway.app/api/request/create-request"),
                    body: jsonEncode({
                      "to_event": widget.eventId,
                      "to_sub_event": widget.subEventId,
                      "position": position
                    }),
                    headers: {
                      "content-type": 'application/json',
                      "session_token": id ?? '',
                    });
                if (response.statusCode == 200) {
                  print(response.body);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Text("Request is sent"),
                  ));
                } else {
                  err = jsonDecode(response.body)["err_msg"];
                }
              },
              innerText: 'Request')
        ],
      ),
    );
  }
}
