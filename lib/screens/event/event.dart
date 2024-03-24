import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/list_of_members.dart';
import 'package:event_manager/screens/event/requests_list.dart';
import 'package:event_manager/screens/event/subevent.dart';
import 'package:event_manager/screens/list_of_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    setId();
    fullEvent = fetchEvent(widget.eventModel);
    screens = [
      FutureBuilder(
        future: fullEvent,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(fullEvent);
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/requests.svg',
                    width: 300,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Access Restricted',
                    style: TextStyle(fontSize: 25),
                  )
                ],
              ),
      ),
      UsersList(
        eventId: widget.eventModel.id,
        subEventId: widget.eventModel.subevents.length > 0
            ? widget.eventModel.subevents[0].id
            : '',
      ),
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventModel.name),
      ),
      body: screens[curr_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curr_index,
          selectedItemColor: const Color.fromARGB(255, 121, 94, 217),
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              curr_index = value;
            });
          },
          items: id == widget.eventModel.studentId
              ? [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.event), label: 'Sub Events'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_sharp),
                      label: 'organizers'),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.request_page_rounded,
                      ),
                      label: 'Requests'),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.inventory_outlined,
                    ),
                    label: 'Invite',
                  ),
                ]
              : [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.event), label: 'Sub Events'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_sharp),
                      label: 'organizers'),
                ]),
    );
  }
}
