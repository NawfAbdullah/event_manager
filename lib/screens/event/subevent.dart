import 'package:event_manager/components/cards/SubEventCard.dart';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/add_sub_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubEvent extends StatefulWidget {
  SubEvent(
      {super.key,
      required this.subEvents,
      required this.event,
      required this.role});
  List<SubEventModel> subEvents;
  String role;

  EventModel event;

  @override
  State<SubEvent> createState() => _SubEventState();
}

class _SubEventState extends State<SubEvent> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String id = '';
  String role = '';
  Future<void> setId() async {
    String? userId = await storage.read(key: 'user_id');
    String? role_ = await storage.read(key: 'role');
    setState(() {
      id = userId ?? '';
      role = role_ ?? "";
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
          height: MediaQuery.of(context).size.height *
              (role == 'participant' ? 0.6 : 0.44),
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
