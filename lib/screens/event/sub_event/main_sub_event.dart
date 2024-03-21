import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/billing/bills.dart';
import 'package:event_manager/screens/billing/upload_bills.dart';
import 'package:event_manager/screens/participants/participants.dart';
import 'package:flutter/material.dart';

class SubEventScaffold extends StatefulWidget {
  SubEventScaffold(
      {super.key, required this.subEvent, required this.eventModel});
  SubEventModel subEvent;
  EventModel eventModel;

  @override
  State<SubEventScaffold> createState() => _SubEventScaffoldState();
}

class _SubEventScaffoldState extends State<SubEventScaffold> {
  int cur_index = 0;
  List screens = [];
  @override
  void initState() {
    super.initState();
    screens = [
      ParticipantsList(
          eventId: widget.eventModel.id, subEventId: widget.subEvent.id),
      Bills(
        subEvent: widget.subEvent,
        event: widget.eventModel,
      ),
      UploadBills(
        subEventModel: widget.subEvent,
        eventModel: widget.eventModel,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subEvent.name),
      ),
      body: screens[cur_index],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              cur_index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism), label: 'participants'),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'bills'),
            BottomNavigationBarItem(
              icon: Icon(Icons.details),
              label: 'upload bills',
            ),
          ]),
    );
  }
}
