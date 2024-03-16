import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';

class SubEventCard extends StatelessWidget {
  const SubEventCard({super.key, required this.subEvent});
  final SubEventModel subEvent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                    subEvent.name,
                    style: TextStyle(fontSize: 30),
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
