import 'dart:convert';

import 'package:event_manager/models/RequestModel.dart';
import 'package:event_manager/screens/participants/participants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({super.key, required this.requestModel});
  final RequestModel requestModel;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            title: Text(
              '${widget.requestModel.requestedBy} is requested to be in ${widget.requestModel.forEvent} as a ${widget.requestModel.position} in ${widget.requestModel.toSubEvent}',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            subtitle: (widget.requestModel.status == "waiting")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularButton(
                        icon: const Icon(Icons.close),
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          FlutterSecureStorage secureStorage =
                              FlutterSecureStorage();
                          final id = await secureStorage.read(key: 'sessionId');
                          final response = await post(
                              Uri.parse(
                                  'https://event-management-backend.up.railway.app/api/request/reject-request'),
                              body: jsonEncode({'request_id': widget.requestModel.id}),
                              headers: {
                                'session_token': id ?? '',
                                'content-type': 'application/json'
                              });
                          setState(() {
                            isLoading = false;
                          });
                          if (response.statusCode == 200) {
                            print(response.body);
                            setState(() {
                              widget.requestModel.status = "rejected";
                            });
                          } else {
                            print("there is error");
                            print(response.body);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircularButton(
                        icon: Icon(Icons.add_reaction),
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          FlutterSecureStorage secureStorage =
                              FlutterSecureStorage();
                          final id = await secureStorage.read(key: 'sessionId');
                          final response = await post(
                              Uri.parse(
                                  'https://event-management-backend.up.railway.app/api/request/accept-request'),
                              body: jsonEncode({'request_id': widget.requestModel.id}),
                              headers: {
                                'session_token': id ?? '',
                                'content-type': 'application/json'
                              });
                          setState(() {
                            isLoading = false;
                          });
                          if (response.statusCode == 200) {
                            print(response.body);
                            print('suckkkksus');
                            setState(() {
                              widget.requestModel.status = "approved";
                            });
                          } else {
                            print('errrrrrrrrrrrrrrrorrrrrrrrrrrrrr');
                            print(response.body);
                          }
                        },
                      ),
                    ],
                  )
                : SizedBox(
                    width: 200,
                    child: Tablet(
                      color: widget.requestModel.status == 'approved'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      text: widget.requestModel.status,
                      icon: Icons.verified,
                    ),
                  ),
          );
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final Icon icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border:
              Border.all(color: Color.fromARGB(255, 183, 125, 249), width: 1),
        ),
        child: icon,
      ),
    );
  }
}
