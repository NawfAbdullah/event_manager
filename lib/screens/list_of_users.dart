import 'dart:convert';

import 'package:event_manager/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class UsersList extends StatefulWidget {
  UsersList({super.key, required this.eventId, required this.subEventId});
  String eventId;
  String subEventId;
  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  Future<List<KuttyUser>> users = getAllVolunteers();
  String text = 'Invite';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].email),
                    trailing: GestureDetector(
                        onTap: () async {
                          FlutterSecureStorage storage = FlutterSecureStorage();
                          final id = await storage.read(key: 'sessionId');
                          final response = await post(
                              Uri.parse(
                                  'https://event-management-backend.up.railway.app/api/invitation/create-invitation'),
                              body: jsonEncode({
                                "from_event": widget.eventId,
                                "from_sub_event": widget.subEventId,
                                "to_user": snapshot.data![index].id,
                                "position": "treasurer"
                              }),
                              headers: {
                                'Content-type': 'application/json',
                                'session_token': id ?? ''
                              });
                          print(response.statusCode);
                          print(response.body);
                          if (response.statusCode == 200) {
                            setState(() {
                              text = 'Invited';
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: const Border(
                                  top: BorderSide(
                                      color: Color.fromARGB(255, 134, 84, 241),
                                      width: 3),
                                  left: BorderSide(
                                      color: Color.fromARGB(255, 134, 84, 241),
                                      width: 3),
                                  right: BorderSide(
                                      color: Color.fromARGB(255, 134, 84, 241),
                                      width: 3),
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 134, 84, 241),
                                      width: 3))),
                          child: Text(text),
                        )),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        }
      },
    );
  }
}
