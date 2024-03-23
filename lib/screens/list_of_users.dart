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
                  return ListItem(
                    eventId: widget.eventId,
                    subEventId: widget.subEventId,
                    curr_user: snapshot.data![index],
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

class ListItem extends StatefulWidget {
  ListItem(
      {super.key,
      required this.eventId,
      required this.subEventId,
      required this.curr_user});
  final String eventId;
  final String subEventId;
  final KuttyUser curr_user;
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  String text = 'Invite';
  bool invited = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.curr_user.name),
      subtitle: Text(widget.curr_user.email),
      trailing: GestureDetector(
          onTap: () async {
            FlutterSecureStorage storage = FlutterSecureStorage();
            final id = await storage.read(key: 'sessionId');
            final response = await post(
                Uri.parse(
                  'https://event-management-backend.up.railway.app/api/invitation/create-invitation',
                ),
                body: jsonEncode({
                  "from_event": widget.eventId,
                  "from_sub_event": widget.subEventId,
                  "to_user": widget.curr_user.id,
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
                text = 'Sent';
                invited = true;
              });
            } else {
              setState(() {
                text = 'Invited';
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: invited
                    ? Color.fromARGB(255, 67, 227, 131)
                    : Color.fromARGB(255, 134, 84, 241),
                border: Border(
                    top: BorderSide(
                        color: invited
                            ? Color.fromARGB(255, 67, 227, 131)
                            : Color.fromARGB(255, 134, 84, 241),
                        width: 2),
                    left: BorderSide(
                        color: invited
                            ? Color.fromARGB(255, 67, 227, 131)
                            : Color.fromARGB(255, 134, 84, 241),
                        width: 2),
                    right: BorderSide(
                        color: invited
                            ? Color.fromARGB(255, 67, 227, 131)
                            : Color.fromARGB(255, 134, 84, 241),
                        width: 2),
                    bottom: BorderSide(
                        color: invited
                            ? Color.fromARGB(255, 67, 227, 131)
                            : Color.fromARGB(255, 134, 84, 241),
                        width: 2))),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
