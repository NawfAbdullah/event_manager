import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class EventModel {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;
  final String department;

  EventModel(
      {required this.id,
      required this.name,
      required this.start,
      required this.end,
      required this.department});

  EventModel.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        start = DateTime(json['date_from']),
        end = DateTime(json['date_to']),
        id = json['_id'],
        department = json['department'];
}

Future<List<Map<String, dynamic>>> fetchAllEvents() async {
  FlutterSecureStorage _storage = FlutterSecureStorage();
  final session = await _storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          'https://event-management-backend.up.railway.app/api/event/get-all'),
      headers: {
        'session_token': session ?? '',
      });

  print('dddddddddddddddddddddddddddddddddddddddddd');
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> x = jsonDecode(response.body);
    print(x[0]['name']);
    List<EventModel> temp = [];
    // print('outsideloop');
    // for (var element in x) {
    //   print('entnter');
    //   EventModel newPart = EventModel.fromJSON(element);
    //   print('vvvvvvvvvvvvvv');
    //   print(newPart);
    //   print('printed new partic');
    //   temp.add(newPart);
    // }
    print(
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    // print(temp);
    return x;
  } else {
    print('exited');
    throw Exception(response.body);
  }
}

class SubEventModel {
  final String name;
  final String eventManager;
  List<String> participants = [];
  SubEventModel({required this.name, required this.eventManager});
}
