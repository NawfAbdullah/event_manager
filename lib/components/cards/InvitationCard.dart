import 'dart:convert';
import 'package:event_manager/models/InvitationModel.dart';
import 'package:event_manager/screens/participants/participants.dart';
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
  bool isLoading = false;
  Color backColor = Colors.transparent;
  String err_msg = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListTile(
        tileColor: err_msg.length > 0 ? Colors.grey : backColor,
        leading: Image.asset(
          'assets/images/letter.png',
          width: 50,
        ),
        title: Text(
          err_msg.length > 0
              ? "Invitation Expired"
              : "Invited as ${widget.invitationModel.postion} for ${widget.invitationModel.eventName}",
          style: TextStyle(
              fontSize: 20,
              color: err_msg.length > 0
                  ? const Color.fromARGB(255, 239, 225, 225)
                  : Colors.black),
        ),
        subtitle: err_msg.length > 0
            ? const SizedBox()
            : (widget.invitationModel.status == "waiting"
                ? (isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              FlutterSecureStorage storage =
                                  FlutterSecureStorage();
                              final id = await storage.read(key: 'sessionId');
                              final response = await post(
                                  Uri.parse(
                                    'https://event-management-backend.up.railway.app/api/invitation/accept-invitation',
                                  ),
                                  body: jsonEncode({
                                    "invitation_id": widget.invitationModel.id
                                  }),
                                  headers: {
                                    'content-type': 'application/json',
                                    'session_token': id ?? '',
                                  });
                              setState(() {
                                isLoading = false;
                              });
                              if (response.statusCode == 200) {
                                setState(() {
                                  isDone = true;
                                  backColor = Colors.greenAccent;
                                });
                                widget.invitationModel.status = 'approved';
                              } else {
                                print(response.body);
                                setState(() {
                                  backColor = Colors.redAccent;
                                  err_msg = 'eeerrrrrrrr';
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 54, 167, 114),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                              FlutterSecureStorage storage =
                                  FlutterSecureStorage();
                              final id = await storage.read(key: 'sessionId');
                              final response = await post(
                                  Uri.parse(
                                    'https://event-management-backend.up.railway.app/api/invitation/reject-invitation',
                                  ),
                                  body: jsonEncode({
                                    "invitation_id": widget.invitationModel.id
                                  }),
                                  headers: {
                                    'content-type': 'application/json',
                                    'session_token': id ?? '',
                                  });
                              if (response.statusCode == 200) {
                                setState(() {
                                  isDone = true;
                                  backColor = Colors.greenAccent;
                                });
                                widget.invitationModel.status = 'rejected';
                              } else {
                                print(response.body);
                                setState(() {
                                  backColor = Colors.redAccent;
                                  err_msg = 'eeeeeeeeerrrrr';
                                });
                              }
                            },
                            child: Container(
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          )
                        ],
                      ))
                : Tablet(
                    color: widget.invitationModel.status == "approved"
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    text: widget.invitationModel.status,
                    icon: widget.invitationModel.status == "approved"
                        ? Icons.verified
                        : Icons.close)),
      ),
    );
  }
}

//<a href="https://www.flaticon.com/free-icons/invitation" title="invitation icons">Invitation icons created by Vectors Tank - Flaticon</a>
