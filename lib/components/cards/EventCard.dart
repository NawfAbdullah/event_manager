import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventCard extends StatelessWidget {
  EventCard({required this.eventModel});
  FlutterSecureStorage storage = FlutterSecureStorage();
  final EventModel eventModel;
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

  Map<String, String> dept_decr = {
    'cse': 'assets/images/desktop.png',
    "ece": 'assets/images/satellite-dish.png',
    "eee": 'assets/images/lighting.png',
    "mech": 'assets/images/construction.png',
    "biotech": 'assets/images/biology.png',
  };
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final role = await storage.read(key: 'role');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Event(
                  eventModel: eventModel,
                  role: role ?? '',
                )));
      },
      child: Container(
        decoration: kCardDecoration,
        height: 80,
        width: MediaQuery.sizeOf(context).width - 15,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffFCFFF1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  dept_decr[eventModel.department] ?? '',
                  width: 20,
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eventModel.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${eventModel.start.day} ${months[eventModel.start.month]} ${eventModel.end != eventModel.start ? '-' : ''} ${eventModel.end != eventModel.start ? eventModel.end.day : ''} ${eventModel.end != eventModel.start ? months[eventModel.end.month] : ''}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 158, 148, 148),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/computer" title="computer icons">Computer icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/biology" title="biology icons">Biology icons created by Eucalyp - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/construction" title="construction icons">Construction icons created by wanicon - Flaticon</a>