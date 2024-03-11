import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard(
      {required this.eventName,
      required this.eventDate,
      required this.eventEndDate});
  final String eventName;
  final DateTime eventDate;
  final DateTime eventEndDate;
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
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 5,
              height: 95,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 121, 94, 217),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.all(10),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    '${eventDate.day} ${months[eventDate.month]} - ${eventEndDate.day} ${months[eventEndDate.month]}',
                    style: TextStyle(
                      fontSize: 20,
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
