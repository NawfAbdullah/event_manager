import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';

class ListOfMembers extends StatelessWidget {
  ListOfMembers({super.key, required this.event});
  EventModel event;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          try {
            if (event.volunteer.length > 0) {
              return Text(event.volunteer[index]['name']);
            } else {
              Text('No volunteers yet');
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
