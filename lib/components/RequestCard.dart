import 'dart:convert';

import 'package:event_manager/models/RequestModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.requestModel});
  final RequestModel requestModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      height: 150,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(31, 255, 145, 145),
              offset: Offset(5, 5),
              blurRadius: 10,
              spreadRadius: 12,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${requestModel.requestedBy} is requested to be in ${requestModel.forEvent} as a ${requestModel.position} in ${requestModel.toSubEvent}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularButton(
                icon: const Icon(Icons.close),
                onTap: () async {
                  FlutterSecureStorage secureStorage = FlutterSecureStorage();
                  final id = await secureStorage.read(key: 'sessionId');
                  final response = await post(
                      Uri.parse(
                          'https://event-management-backend.up.railway.app/api/request/reject-request'),
                      body: jsonEncode({'request_id': requestModel.id}),
                      headers: {
                        'session_token': id ?? '',
                        'content-type': 'application/json'
                      });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              CircularButton(
                icon: Icon(Icons.add_reaction),
                onTap: () async {
                  FlutterSecureStorage secureStorage = FlutterSecureStorage();
                  final id = await secureStorage.read(key: 'sessionId');
                  final response = await post(
                      Uri.parse(
                          'https://event-management-backend.up.railway.app/api/request/accept-request'),
                      body: jsonEncode({'request_id': requestModel.id}),
                      headers: {
                        'session_token': id ?? '',
                        'content-type': 'application/json'
                      });
                  if (response.statusCode == 200) {
                    print(response.body);
                    print('suckkkksus');
                  } else {
                    print('errrrrrrrrrrrrrrrorrrrrrrrrrrrrr');
                    print(response.body);
                  }
                },
              ),
            ],
          )
        ],
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
          border: const Border(
            bottom: BorderSide(width: 1, color: Colors.blueAccent),
            top: BorderSide(width: 1, color: Colors.blueAccent),
            left: BorderSide(width: 1, color: Colors.blueAccent),
            right: BorderSide(width: 1, color: Colors.blueAccent),
          ),
        ),
        child: icon,
      ),
    );
  }
}