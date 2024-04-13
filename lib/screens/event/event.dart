import 'package:event_manager/components/cards/TheCard.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/list_of_members.dart';
import 'package:event_manager/screens/event/requests_list.dart';
import 'package:event_manager/screens/event/subevent.dart';
import 'package:event_manager/screens/list_of_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Event extends StatefulWidget {
  const Event({super.key, required this.eventModel, required this.role});
  final EventModel eventModel;
  final String role;
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  late List<Widget> screens;

  late final Future<EventModel> fullEvent;
  FlutterSecureStorage storage = FlutterSecureStorage();
  String id = '';
  String role = '';
  int curr_index = 0;
  Future<void> setId() async {
    String? userId = await storage.read(key: 'user_id');
    String? _role = await storage.read(key: 'role');
    setState(() {
      id = userId ?? '';
      role = _role ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    setId();
    fullEvent = fetchEvent(widget.eventModel);
    print('sosfofesdf');
    print(widget.eventModel.subevents);
    screens = [
      MainEventScreen(
          fullEvent: fullEvent, eventModel: widget.eventModel, role: role),
      ListOfMembers(event: widget.eventModel),
      Container(
        child: id == widget.eventModel.studentId
            ? RequestList(eventId: widget.eventModel.id)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/request.svg',
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
      FutureBuilder(
          future: fullEvent,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              default:
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return UsersList(
                    eventId: widget.eventModel.id,
                    subEvents: snapshot.data!.subevents,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
            }
          }),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[curr_index],
      bottomNavigationBar: role == 'participant'
          ? null
          : BottomNavigationBar(
              currentIndex: curr_index,
              selectedItemColor: const Color(0xff92a95f),
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

class MainEventScreen extends StatelessWidget {
  MainEventScreen(
      {super.key,
      required this.fullEvent,
      required this.eventModel,
      required this.role});
  Future<EventModel> fullEvent;
  EventModel eventModel;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String role;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: Image.asset(
            'assets/images/nature.jpg',
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TheCard(
                  eventModel.name,
                  icon: Icons.calendar_month,
                  subText:
                      '${eventModel.start.day} ${months[eventModel.start.month]} ${eventModel.end != eventModel.start ? '-' : ''} ${eventModel.end != eventModel.start ? eventModel.end.day : ''} ${eventModel.end != eventModel.start ? months[eventModel.end.month] : ''}',
                ),
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
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height *
                                (role == 'participant' ? 0.54 : 0.5),
                            child: SubEvent(
                              role: role,
                              subEvents: eventModel.subevents,
                              event: eventModel,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//<a href="https://www.vecteezy.com/free-vector/landscape">Landscape Vectors by Vecteezy</a>
//<a href="https://www.flaticon.com/free-icons/branch" title="branch icons">Branch icons created by Good Ware - Flaticon</a>
