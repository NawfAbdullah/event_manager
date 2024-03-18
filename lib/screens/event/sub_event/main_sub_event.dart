import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/billing/bills.dart';
import 'package:event_manager/screens/billing/upload_bills.dart';
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
    // TODO: implement initState
    super.initState();
    screens = [
      Placeholder(),
      UploadBills(
        subEventModel: widget.subEvent,
        eventModel: widget.eventModel,
      ),
      Bills(subEvent: widget.subEvent)
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
                icon: Icon(Icons.details), label: 'details'),
          ]),
    );
  }
}
