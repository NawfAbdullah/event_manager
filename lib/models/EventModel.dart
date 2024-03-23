import 'dart:convert';
import 'package:event_manager/models/UserModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String department;
  User? treasurer;
  String studentId = '';
  List volunteer = [];
  List<SubEventModel> subevents = [];
  String coordinatorName = '';
  EventModel({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.department,
  });

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
      try {
        SubEventModel x = SubEventModel.fromJson(parsed['sub_events'][i]);

        event.AddSubEvent(x);
      } catch (e) {
        print('it is the error');
        print(e);
      }
    }
    event.treasurer =
        parsed["treasurer"] != null ? User.fromJSON(parsed["treasurer"]) : null;
    event.studentId = parsed["student_coordinator"]?["_id"] ?? '';
    event.coordinatorName = parsed["student_coordinator"]?["name"] ?? '';
    print(parsed);
    event.volunteer = parsed["volunteers"] ?? [];
    return event;
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}

Future<List<EventModel>> fetchMyEvents() async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  final myEventStringIds = await storage.read(key: 'my_events');

  List<String> parsedIds = [];
  try {
    parsedIds = parseStringToList(myEventStringIds ?? '[]');
  } catch (err) {
    print('here is the error');
    print(err);
  }
  List<EventModel> currentEvent = [];
  if (parsedIds.length > 0) {
    for (var i = 0; i < parsedIds.length; i++) {
      print(parsedIds[i]);

      final response = await get(
          Uri.parse(
              'https://event-management-backend.up.railway.app/api/event/get-one?id=${parsedIds[i]}'),
          headers: {
            'session_token': session ?? '',
          });
      print(parsedIds[i]);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        EventModel myEvent = EventModel.fromJson(parsed);
        currentEvent.add(myEvent);
      } else {
        print('here is another error');
        print(response.body);
        throw Exception(response.body);
      }
    }
  }

  return currentEvent;
}

class SubEventModel {
  final String name;
  final String eventManager;
  final String id;
  List<String> participants = [];
  SubEventModel({
    required this.name,
    required this.eventManager,
    required this.id,
  });

  SubEventModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        eventManager = json["event_manager"]?["name"] ?? '';
}

List<String> parseStringToList(String input) {
  // Remove '[' and ']' characters from the input string
  String trimmedString = input.substring(1, input.length - 1);

  // Split the trimmed string by ', ' to get individual elements
  List<String> elements = trimmedString.split(', ');
  return elements;
}
