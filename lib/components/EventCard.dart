import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard({required name, required eventDate});
  late final String name;
  late final String eventDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kCardDecoration.copyWith(color: Colors.blue),
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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '24',
                  style: TextStyle(
                    fontSize: 30,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Oct',
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            children: [
              Text(
                'BeCrez',
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
    );
  }
}
