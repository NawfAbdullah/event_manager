import 'dart:convert';

import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/billing/bills.dart';
import 'package:event_manager/screens/billing/upload_bills.dart';
import 'package:event_manager/screens/participants/add_particpants.dart';
import 'package:event_manager/screens/participants/participants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class SubEventScaffold extends StatefulWidget {
  SubEventScaffold(
      {super.key,
      required this.subEvent,
      required this.eventModel,
      required this.role});
  SubEventModel subEvent;
  EventModel eventModel;
  String role;

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
      SubEventIntroduction(
        subEventModel: widget.subEvent,
        role: widget.role,
        eventId: widget.eventModel.id,
      ),
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
      bottomNavigationBar: widget.role == 'participant'
          ? null
          : BottomNavigationBar(
              currentIndex: cur_index,
              onTap: (value) {
                setState(() {
                  cur_index = value;
                });
              },
              selectedItemColor: Color(0xff92a95f),
              unselectedItemColor: Colors.grey,
              items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.interests),
                    label: 'Intro',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.volunteer_activism),
                      label: 'participants'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.note), label: 'bills'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.details),
                    label: 'upload bills',
                  ),
                ]),
      floatingActionButton: widget.role == 'participant'
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddParticpantScreen(
                        eventId: widget.eventModel.id,
                        subEventId: widget.subEvent.id)));
              },
            ),
    );
  }
}

class SubEventIntroduction extends StatefulWidget {
  SubEventIntroduction(
      {super.key,
      required this.subEventModel,
      required this.role,
      required this.eventId});
  SubEventModel subEventModel;
  String eventId;
  String role;

  @override
  State<SubEventIntroduction> createState() => _SubEventIntroductionState();
}

class _SubEventIntroductionState extends State<SubEventIntroduction> {
  bool isLoading = false;
  bool alreadyRegister = false;
  String error = '';
  String buttonText = 'Enroll';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.subEventModel.img,
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.365,
              child: ListView(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                      widget.subEventModel.name,
                      style: kTitleText.copyWith(fontSize: 30),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Text(
                      widget.subEventModel.description,
                      style: kSubText.copyWith(color: Colors.grey),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            )
          ]),
          widget.role != 'participant'
              ? SizedBox()
              : isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SubmitButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        FlutterSecureStorage storage = FlutterSecureStorage();
                        if (!alreadyRegister) {
                          final session_token =
                              await storage.read(key: 'sessionId');
                          final response = await post(
                              Uri.parse(
                                  'https://event-management-backend.up.railway.app/api/participant/enroll'),
                              body: jsonEncode({
                                "event_id": widget.eventId,
                                "sub_event_id": widget.subEventModel.id,
                                "contact_no": "9293956439",
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
        ],
      ),
    );
  }
}
