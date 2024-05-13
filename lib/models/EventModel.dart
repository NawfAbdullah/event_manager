import 'dart:collection';
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
        end = DateTime.parse(json['date_to'] ?? json['date_from']),
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
  List<EventModel> currentEvent = [];
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  // final myEventStringIds = await storage.read(key: 'my_events');
  final id = await storage.read(key: 'sessionId');
  final response = await post(
      Uri.parse(
          'https://event-management-backend.up.railway.app/api/auth/verify-session'),
      body: jsonEncode({
        'session_token': id,
      }),
      headers: {
        'admin-access-code': '044453c2-e45a-4c5d-91b5-c3c14a483d61',
        'Content-Type': 'application/json',
      });
  List<String> parsedIds = [];
  if (response.statusCode == 200) {
    User user = User.fromJSON(jsonDecode(response.body));
    user.myEvents = LinkedHashSet<String>.from(user.myEvents).toList();

    await saveCurrentUser(user);

    if (user.myEvents.length > 0) {
      for (var i = 0; i < user.myEvents.length; i++) {
        print(user.myEvents[i]);
        final response = await get(
            Uri.parse(
                'https://event-management-backend.up.railway.app/api/event/get-one?id=${user.myEvents[i] is String ? user.myEvents[i] : user.myEvents[i]['event_id']}'),
            headers: {
              'session_token': session ?? '',
            });
        print(user.myEvents[i]);
        if (response.statusCode == 200) {
          final parsed = jsonDecode(response.body);
          print(parsed);
          EventModel myEvent = EventModel.fromJson(parsed);
          currentEvent.add(myEvent);
        } else {
          print('here is another error');
          print(response.body);
          throw Exception(response.body);
        }
      }
    }
  } else {
    throw Exception(response.body);
  }

  return currentEvent;
}

//{_id: 66148b9afd5e9ba98f1cf91b, name: Hackathon, description: You heard it right! This is damn good baby, img: https://images.pexels.com/photos/20732688/pexels-photo-20732688/free-photo-of-man-in-suit-standing-in-lake.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2}
class SubEventModel {
  final String name;
  final String eventManager;
  final String id;
  final String description;
  final String img;
  List<String> participants = [];
  SubEventModel({
    required this.name,
    required this.eventManager,
    required this.id,
    required this.description,
    required this.img,
  });

  SubEventModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        eventManager = json["event_manager"]?["name"] ?? '',
        description = json['description'],
        img = json['img'];
}

List<String> parseStringToList(String input) {
  // Remove '[' and ']' characters from the input string
  String trimmedString = input.substring(1, input.length - 1);

  // Split the trimmed string by ', ' to get individual elements
  List<String> elements = trimmedString.split(', ');
  return elements;
}

Future<List<EventModel>> fetchDayEvents(DateTime date) async {
  print("${date.year}-0${date.month}-${date.day}");
  const FlutterSecureStorage storage = FlutterSecureStorage();
  final session = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          'https://event-management-backend.up.railway.app/api/event/get-on-date?date=${date.year}-0${date.month}-${date.day}&include_sub_events=1'),
      headers: {
        'session_token': session ?? '',
      });
  print(response.body);
  if (response.statusCode == 200) {
    print('goot');
    return parseEvents(response.body);
  } else {
    print(response.body);
    throw Exception(response.body);
  }
}

List<EventModel> parseEvents(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
  List<EventModel> finale = [];
  for (var i = 0; i < parsed.length; i++) {
    try {
      EventModel x = EventModel.fromJson(parsed[i]['data']);
      finale.add(x);
    } catch (err) {
      print(err);
    }
  }
  return finale;
}
