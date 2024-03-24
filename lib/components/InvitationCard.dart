import 'dart:convert';
import 'package:event_manager/models/InvitationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class InvitationCard extends StatefulWidget {
  InvitationCard({super.key, required this.invitationModel});
  InvitationModel invitationModel;

  @override
  State<InvitationCard> createState() => _InvitationCardState();
}

class _InvitationCardState extends State<InvitationCard> {
  bool isDone = false;
  Color backColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backColor,
      title: Text(
        "Invited as ${widget.invitationModel.postion} for ${widget.invitationModel.eventName}",
        style: const TextStyle(fontSize: 20),
      ),
      subtitle: Row(
        children: [
          GestureDetector(
            onTap: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              final id = await storage.read(key: 'sessionId');
              final response = await post(
                  Uri.parse(
                    'https://event-management-backend.up.railway.app/api/invitation/accept-invitation',
                  ),
                  body:
                      jsonEncode({"invitation_id": widget.invitationModel.id}),
                  headers: {
                    'content-type': 'application/json',
                    'session_token': id ?? '',
                  });
              if (response.statusCode == 200) {
                setState(() {
                  isDone = true;
                  backColor = Colors.greenAccent;
                });
              } else {
                print(response.body);
                setState(() {
                  backColor = Colors.redAccent;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 66, 137, 104),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: !isDone
                    ? [
                        Icon(
                          Icons.add_moderator_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        Text('Successfull')
                      ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              final id = await storage.read(key: 'sessionId');
              final response = await post(
                  Uri.parse(
                    'https://event-management-backend.up.railway.app/api/invitation/reject-invitation',
                  ),
                  body:
                      jsonEncode({"invitation_id": widget.invitationModel.id}),
                  headers: {
                    'content-type': 'application/json',
                    'session_token': id ?? '',
                  });
              if (response.statusCode == 200) {
                setState(() {
                  isDone = true;
                  backColor = Colors.greenAccent;
                });
              } else {
                print(response.body);
                setState(() {
                  backColor = Colors.redAccent;
                });
              }
            },
            child: Container(
              child: Text('Reject'),
            ),
          )
        ],
      ),
    );
  }
}
