import 'package:event_manager/components/EventCard.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/create_event.dart';
import 'package:event_manager/screens/profile.dart';
import 'package:event_manager/screens/scanner/results.dart';
import 'package:event_manager/screens/scanner/scanner.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  int current_index = 0;
  List<Widget> screens = [
    MainEvent(),
    Scanner(),
    CreateEvent(),
    Placeholder(),
    Profile(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: screens[current_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: current_index,
          selectedItemColor: Color.fromARGB(255, 121, 94, 217),
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              current_index = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.scanner), label: 'Scanner'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}

class MainEvent extends StatefulWidget {
  const MainEvent({
    super.key,
  });

  @override
  State<MainEvent> createState() => _MainEventState();
}

class _MainEventState extends State<MainEvent> {
  Future<List<Map<String, dynamic>>> events = fetchAllEvents();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: events,
    //     builder: (context, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return const Center(child: CircularProgressIndicator());
    //         default:
    //           if (snapshot.hasData) {
    //             print('xxxxxxxxxxvrsgrdfgrdf');
    //             print(snapshot.data);
    //             return ListView.builder(
    //                 itemCount: snapshot.data?.length,
    //                 itemBuilder: (context, index) {
    //                   return EventCard(
    //                       eventName: snapshot.data?[index]['name'] ?? '',
    //                       eventDate:
    //                           DateTime(snapshot.data?[index]['date_from']) ??
    //                               DateTime.now());
    //                 });
    //           } else {
    //             print(events);
    //             print('ddddddddd');
    //             print(snapshot.data);
    //             return Text('No Event Available');
    //           }
    //       }
    //     });

    return ListView(
      children: [
        EventCard(eventName: 'Becrez', eventDate: DateTime.now()),
        EventCard(eventName: 'Arcane', eventDate: DateTime.now()),
        EventCard(eventName: 'Cresathon', eventDate: DateTime.now()),
      ],
    );
  }
}
