import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String department;
  final List<SubEventModel> subevents = [];

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
    return parsePhotos(response.body);
  } else {
    throw Exception(response.body);
  }
}

class SubEventModel {
  final String name;
  final String eventManager;
  List<String> participants = [];
  SubEventModel({required this.name, required this.eventManager});

  SubEventModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        eventManager = '';
}
