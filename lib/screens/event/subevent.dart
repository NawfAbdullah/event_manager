import 'package:event_manager/components/SubEventCard.dart';
import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/add_sub_event.dart';
import 'package:flutter/material.dart';

class SubEvent extends StatelessWidget {
  SubEvent({super.key, required this.subEvents, required this.event});
  List<SubEventModel> subEvents;
  EventModel event;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
              itemCount: subEvents.length,
              itemBuilder: (context, index) {
                return SubEventCard(subEvent: subEvents[index]);
              }),
        ),
        SubmitButton(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddSubEvent(event: event),
                ),
              );
            },
            innerText: 'Add Sub Event')
      ],
    );
  }
}
