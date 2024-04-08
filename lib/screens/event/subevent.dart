import 'package:event_manager/components/cards/SubEventCard.dart';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/add_sub_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubEvent extends StatefulWidget {
  SubEvent({super.key, required this.subEvents, required this.event});
  List<SubEventModel> subEvents;

  EventModel event;

  @override
  State<SubEvent> createState() => _SubEventState();
}

class _SubEventState extends State<SubEvent> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String id = '';
  Future<void> setId() async {
    String? userId = await storage.read(key: 'user_id');
    setState(() {
      id = userId ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.44,
          child: ListView.builder(
              itemCount: widget.subEvents.length,
              itemBuilder: (context, index) {
                return SubEventCard(
                  subEvent: widget.subEvents[index],
                  event: widget.event,
                );
              }),
        ),
        id == widget.event.studentId
            ? SubmitButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddSubEvent(event: widget.event),
                    ),
                  );
                },
                innerText: 'Add Sub Event')
            : const SizedBox(
                height: 5,
              )
      ],
    );
  }
}
