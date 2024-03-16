import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/subevent.dart';
import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  Event({super.key, required this.eventModel});
  // final String EventId;
  // final String EventName;
  final EventModel eventModel;
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  late List<Widget> screens;

  late final Future<EventModel> fullEvent;
  int curr_index = 0;
  @override
  void initState() {
    super.initState();
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
      Placeholder(),
      Placeholder(),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.subscript), label: 'Bills'),
          ]),
    );
  }
}
