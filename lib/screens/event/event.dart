import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/list_of_members.dart';
import 'package:event_manager/screens/event/requests_list.dart';
import 'package:event_manager/screens/event/subevent.dart';
import 'package:event_manager/screens/requests/list_of_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Event extends StatefulWidget {
  const Event({super.key, required this.eventModel});
  final EventModel eventModel;
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  late List<Widget> screens;

  late final Future<EventModel> fullEvent;
  FlutterSecureStorage storage = FlutterSecureStorage();
  String id = '';
  int curr_index = 0;
  Future<void> setId() async {
    String? userId = await storage.read(key: 'user_id');
    setState(() {
      id = userId ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    setId();
    fullEvent = fetchEvent(widget.eventModel);
    screens = [
      FutureBuilder(
        future: fullEvent,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                return SubEvent(
                  subEvents: widget.eventModel.subevents,
                  event: widget.eventModel,
                );
              } else {
                return const CircularProgressIndicator();
              }
          }
        },
      ),
      // ,
      ListOfMembers(event: widget.eventModel),
      Container(
        child: id == widget.eventModel.studentId
            ? RequestList(eventId: widget.eventModel.id)
            : Text('Access Restricted'),
      )
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventModel.name),
      ),
      body: screens[curr_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curr_index,
          selectedItemColor: Color.fromARGB(255, 121, 94, 217),
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              curr_index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.event), label: 'Sub Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_sharp),
                label: 'organizers'),
            id == widget.eventModel.studentId
                ? BottomNavigationBarItem(
                    icon: Icon(
                      Icons.request_page_rounded,
                    ),
                    label: 'Requests')
                : BottomNavigationBarItem(
                    icon: Icon(Icons.lock), label: 'Locked')
          ]),
    );
  }
}
