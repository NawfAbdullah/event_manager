import 'dart:convert';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AddSubEvent extends StatefulWidget {
  const AddSubEvent({super.key, required this.event});
  final EventModel event;
  @override
  State<AddSubEvent> createState() => _AddSubEventState();
}

class _AddSubEventState extends State<AddSubEvent> {
  String subEventName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  subEventName = value;
                });
              },
              decoration: kInputdecoration.copyWith(
                hintText: '',
                labelText: 'Sub Event Name',
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SubmitButton(
              onTap: () async {
                FlutterSecureStorage storage = FlutterSecureStorage();
                final id = await storage.read(key: 'sessionId');
                final response = await post(
                    Uri.parse(
                      'https://event-management-backend.up.railway.app/api/sub-event/create',
                    ),
                    body: jsonEncode({
                      'name': subEventName,
                      'event_id': widget.event.id,
                    }),
                    headers: {
                      'content-type': 'application/json',
                      'session_token': id ?? ''
                    });
                if (response.statusCode == 200) {
                  print(response.body);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Event(eventModel: widget.event);
                    },
                  ));
                } else {
                  print(response.body);
                }
              },
              innerText: 'Submit')
        ],
      ),
    );
  }
}
