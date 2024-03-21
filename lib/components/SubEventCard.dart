import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/sub_event/main_sub_event.dart';
import 'package:event_manager/screens/requests/RequestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubEventCard extends StatelessWidget {
  SubEventCard({super.key, required this.subEvent, required this.event});
  FlutterSecureStorage storage = FlutterSecureStorage();
  final SubEventModel subEvent;
  final EventModel event;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? eventsString = await storage.read(key: 'my_events');
        List<String> myEvents = parseStringToList(eventsString ?? '[a,b]');
        if (myEvents.contains(subEvent.id) || myEvents.contains(event.id)) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubEventScaffold(
                    subEvent: subEvent,
                    eventModel: event,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return RequestPage(eventId: event.id, subEventId: subEvent.id);
            },
          ));
        }
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
        height: 80,
        width: MediaQuery.sizeOf(context).width - 15,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 5,
              height: 95,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 121, 94, 217),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.all(10),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    subEvent.name,
                    style: const TextStyle(fontSize: 30),
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
