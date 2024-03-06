import 'package:event_manager/components/EventCard.dart';
import 'package:event_manager/screens/event/create_event.dart';
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
    ResultScreen(
        uuid:
            '{"event_id": "65e70e3de866130d9ecf0331","sub_event_id": "65e71058565383b93a39ef9e","participant_id": "65e718aa55f9d2aed96f2b57"}')
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

class MainEvent extends StatelessWidget {
  const MainEvent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        EventCard(eventName: 'Becrez', eventDate: '10'),
        EventCard(eventName: 'Arcane', eventDate: '10'),
        EventCard(eventName: 'Cresathon', eventDate: '10'),
      ],
    );
  }
}
