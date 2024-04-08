import 'package:event_manager/components/profile_icons.dart';
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
        final role = await storage.read(key: 'role');
        if (myEvents.contains(subEvent.id) ||
            myEvents.contains(event.id) ||
            role == 'hod') {
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
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: kCardDecoration,
        height: 80,
        width: MediaQuery.sizeOf(context).width - 15,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subEvent.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          const ProfileIcon(),
                          Text(
                            "${subEvent.participants.length.toString()}+",
                            style: kSubText.copyWith(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
