import 'package:event_manager/components/cards/EventCard.dart';
import 'package:event_manager/components/cards/TheCard.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/create_event.dart';
import 'package:event_manager/screens/profile.dart';
import 'package:event_manager/screens/scanner/scanner.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  EventScreen({super.key, required this.role});
  String role;
  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  int current_index = 0;

  late List<Widget> screens;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      screens = widget.role == 'studentcoordinator'
          ? [
              MyEvents(),
              Scanner(),
              CreateEvent(),
              MainEvent(),
              Profile(),
            ]
          : widget.role == 'participant'
              ? [
                  MyEvents(),
                  MainEvent(),
                ]
              : [
                  MyEvents(),
                  Scanner(),
                  MainEvent(),
                  Profile(),
                ];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/leader.png',
          width: 100,
        ),
        title: const Text('Events'),
        centerTitle: true,
      ),
      body: screens[current_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: current_index,
          selectedItemColor: Color(0xff92a95f),
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              current_index = value;
            });
          },
          items: widget.role == 'studentcoordinator'
              ? [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.scanner), label: 'Scanner'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.add), label: 'Create'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month), label: 'Calendar'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Profile'),
                ]
              : widget.role == 'participant'
                  ? [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month), label: 'Calendar'),
                    ]
                  : [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.scanner), label: 'Scanner'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month), label: 'Calendar'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: 'Profile'),
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
  Future<List<EventModel>> events = fetchAllEvents();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: events,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Something went wrong'),
                );
              } else if (snapshot.hasData) {
                print('xxxxxxxxxxvrsgrdfgrdf');
                print(snapshot.data);
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                          eventModel: snapshot.data?[index] ??
                              EventModel(
                                id: '',
                                name: '',
                                start: DateTime.now(),
                                end: DateTime.now(),
                                department: '',
                              ));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        });
  }
}

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  Future<List<EventModel>> events = fetchMyEvents();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TheCard(
          'Hey Shakir',
          icon: Icons.notifications_active,
          subText: 'Student Coordinator',
        ),
        FutureBuilder(
            future: events,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                      child: Text('No events'),
                    );
                  } else if (snapshot.hasData) {
                    print(snapshot.data);
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return EventCard(
                              eventModel: snapshot.data?[index] ??
                                  EventModel(
                                    id: '',
                                    name: '',
                                    start: DateTime.now(),
                                    end: DateTime.now(),
                                    department: '',
                                  ),
                            );
                          }),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            }),
      ],
    );
  }
}



//<a href="https://www.flaticon.com/free-icons/events" title="events icons">Events icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/event" title="event icons">Event icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/welcome" title="welcome icons">Welcome icons created by Design Circle - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/thunder" title="thunder icons">Thunder icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/radar" title="radar icons">Radar icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/leadership" title="leadership icons">Leadership icons created by Becris - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/leader" title="leader icons">Leader icons created by Flat Icons - Flaticon</a>

