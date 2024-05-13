import 'dart:convert';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class UsersList extends StatefulWidget {
  UsersList({super.key, required this.eventId, required this.subEvents});
  String eventId;
  List<SubEventModel> subEvents;
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
    print('assr');
    print(widget.subEvents);
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
                    subEvents: widget.subEvents,
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
      required this.subEvents,
      required this.curr_user});
  final String eventId;
  List<SubEventModel> subEvents;
  final KuttyUser curr_user;
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool invited = false;
  String position = 'treasurer';
  String text = '';
  String error = '';
  String subEventId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = 'Invite as $position';
  }

  @override
  Widget build(BuildContext context) {
    print('buruuuc');
    print(widget.subEvents.length);
    for (var element in widget.subEvents) {
      print('xxx');
      print(element.name);
    }
    List<DropdownMenuItem> items = widget.subEvents
        .map((e) => DropdownMenuItem(
              value: e.id,
              child: Text(e.name),
            ))
        .toList();
    return ListTile(
      title: Text(widget.curr_user.name),
      subtitle: position == 'eventmanager' || position == 'volunteer'
          ? DropdownButton(
              hint: Text('Sub Event'),
              style: const TextStyle(color: Colors.black),
              icon: const Icon(Icons.lock_person),
              items: items,
              onChanged: (value) {
                setState(() {
                  subEventId = value ?? '';
                });
              })
          : Text(widget.curr_user.email),
      trailing: GestureDetector(
          onLongPress: () {
            setState(() {
              position = position == 'treasurer' ? 'volunteer' : 'treasurer';
              text = 'invite as $position';
            });
          },
          onDoubleTap: () {
            setState(() {
              position = 'eventmanager';
              text = 'Invite a event manager';
            });
          },
          onTap: () async {
            print('started');
            FlutterSecureStorage storage = FlutterSecureStorage();
            final idx = await storage.read(key: 'sessionId');
            print('check point 1');
            print(idx ?? 'cc');
            final response = await post(
                Uri.parse(
                  'https://event-management-backend.up.railway.app/api/invitation/create-invitation',
                ),
                body: jsonEncode({
                  "from_event": widget.eventId,
                  "from_sub_event": subEventId,
                  "to_user": widget.curr_user.id,
                  "position": position
                }),
                headers: {
                  'Content-type': 'application/json',
                  'session_token': idx ?? ''
                });
            print(response.statusCode);
            print(response.body);
            print('check point 2');
            if (response.statusCode == 200) {
              print('check point 3');
              setState(() {
                text = 'Sent';
                invited = true;
              });
            } else {
              print('checkpiint 4');
              setState(() {
                text = 'Already has role';
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
