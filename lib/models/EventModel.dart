import 'dart:convert';

import 'package:event_manager/screens/event/event.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String department;
  List<SubEventModel> subevents = [];

  EventModel(
      {required this.id,
      required this.name,
      required this.start,
      required this.end,
      required this.department});

  void AddSubEvent(SubEventModel x) {
    subevents.add(x);
  }

  EventModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        start = DateTime.parse(json['date_from']),
        end = DateTime.parse(json['date_to']),
        id = json['_id'],
        department = json['department'];
}

List<EventModel> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
  List<EventModel> finale = [];
  for (var i = 0; i < parsed.length; i++) {
    try {
      EventModel x = EventModel.fromJson(parsed[i]);
      finale.add(x);
    } catch (err) {
      print(err);
    }
  }
  return finale;
}

Future<List<EventModel>> fetchAllEvents() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          'https://event-management-backend.up.railway.app/api/event/get-all'),
      headers: {
        'session_token': session ?? '',
      });

  if (response.statusCode == 200) {
    print('goot');
    return parsePhotos(response.body);
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}

Future<EventModel> fetchEvent(EventModel event) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          'https://event-management-backend.up.railway.app/api/event/get-one?id=${event.id}'),
      headers: {
        'session_token': session ?? '',
      });

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    event.subevents = [];
    for (var i = 0; i < parsed["sub_events"].length; i++) {
      SubEventModel x = SubEventModel.fromJson(parsed['sub_events'][i]);
      event.AddSubEvent(x);
    }
    return event;
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}

Future<List<EventModel>> fetchMyEvents() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  final List myEvents = jsonEncode(storage.read(key: 'my_events')) as List;
  List<EventModel> currentEvent = [];
  for (var i = 0; i < myEvents.length; i++) {
    final response = await get(
        Uri.parse(
            'https://event-management-backend.up.railway.app/api/event/get-one?id=${myEvents[i].toString()}'),
        headers: {
          'session_token': session ?? '',
        });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      EventModel myEvent = EventModel.fromJson(parsed);
      currentEvent.add(myEvent);
    } else {
      print(response.body);
      throw Exception(response.body);
    }
  }

  return currentEvent;
}

class SubEventModel {
  final String name;
  final String eventManager;
  final String id;
  List<String> participants = [];
  SubEventModel(
      {required this.name, required this.eventManager, required this.id});

  SubEventModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        eventManager = '';
}




// {
//     "_id": "65edb94c02a225907684602b",
//     "name": "Min Blogging Shit",
//     "date_from": "2024-03-11T00:00:00.000Z",
//     "date_to": "2024-03-13T00:00:00.000Z",
//     "department": "cse",
//     "student_coordinator": {
//         "_id": "65edb85f02a225907684601f",
//         "type": "studentcoordinator",
//         "email": "arbitary@gmail.com",
//         "name": "Arbitary"
//     },
//     "treasurer": null,
//     "volunteers": [],
//     "sub_events": [
//         {
//             "_id": "65ef315102a225907684611b",
//             "name": "Mind Hunter",
//             "participants": [],
//             "bills": []
//         }
//     ]
// }