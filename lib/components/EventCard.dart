import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard({required this.eventName, required this.eventDate});
  final String eventName;
  final DateTime eventDate;
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Event(EventId: '12345678', EventName: eventName)));
      },
      child: Container(
        decoration: kCardDecoration.copyWith(
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: const Color.fromARGB(31, 82, 81, 81),
              offset: Offset(4, 6),
              blurRadius: 10,
              spreadRadius: 10,
            )
          ],
        ),
        height: 100,
        width: MediaQuery.sizeOf(context).width - 15,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    eventDate.day.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    months[eventDate.month],
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.none,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  eventName,
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  '9:00 - 15:00',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
