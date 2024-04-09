import 'dart:convert';

import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/components/profile_icons.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/sub_event/main_sub_event.dart';
import 'package:event_manager/screens/requests/RequestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class SubEventCard extends StatefulWidget {
  SubEventCard({super.key, required this.subEvent, required this.event});
  final SubEventModel subEvent;
  final EventModel event;

  @override
  State<SubEventCard> createState() => _SubEventCardState();
}

class _SubEventCardState extends State<SubEventCard> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String role = '';
  bool isLoading = false;
  String error = '';
  String buttonText = 'Register';
  bool alreadyRegister = false;
  Future<void> getRole() async {
    String? _role = await storage.read(key: 'role');
    setState(() {
      role = _role ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? eventsString = await storage.read(key: 'my_events');
        List<String> myEvents = parseStringToList(eventsString ?? '[a,b]');
        final role = await storage.read(key: 'role');
        if (myEvents.contains(widget.subEvent.id) ||
            myEvents.contains(widget.event.id) ||
            role == 'hod' ||
            role == 'participant') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubEventScaffold(
                    subEvent: widget.subEvent,
                    eventModel: widget.event,
                    role: role ?? '',
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return RequestPage(
                  eventId: widget.event.id, subEventId: widget.subEvent.id);
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subEvent.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const ProfileIcon(),
                          Text(
                            "${widget.subEvent.participants.length.toString()}+",
                            style: kSubText.copyWith(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            role == 'participant'
                ? isLoading
                    ? const CircularProgressIndicator()
                    : SubmitButton(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (!alreadyRegister) {
                            final session_token =
                                await storage.read(key: 'sessionId');
                            final response = await post(
                                Uri.parse(
                                    'https://event-management-backend.up.railway.app/api/participant/enroll'),
                                body: jsonEncode({
                                  "event_id": widget.event.id,
                                  "sub_event_id": widget.subEvent.id,
                                  "contact_no": "",
                                  "college": "BS Abdur Rahman Crescent"
                                }),
                                headers: {
                                  'content-type': 'application/json',
                                  'session_token': session_token ?? ''
                                });
                            setState(() {
                              isLoading = false;
                            });
                            if (response.statusCode == 200) {
                              setState(() {
                                buttonText = 'registered';
                                alreadyRegister = true;
                              });
                            } else {
                              setState(() {
                                error = jsonDecode(response.body)['err_msg'];

                                buttonText = error ==
                                        'A participant with the same email is enrolled in the sub-event'
                                    ? 'Already Enrolled'
                                    : error;
                              });
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                              buttonText = 'Registered';
                            });
                          }
                        },
                        innerText: buttonText)
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
