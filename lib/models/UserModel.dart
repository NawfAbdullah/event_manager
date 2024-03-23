import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class User {
  User({name, email, department, id});
  late String name;
  late String email;
  late String role;
  late String sessionId;
  late String id;
  late List<dynamic> myEvents = [];

  User.fromJSON(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        email = json['email'],
        role = json['type'],
        id = json['_id'],
        myEvents = (json["events_as_studentcoordinator"] ?? []) +
            (json["events_as_eventmanager"] ?? []) +
            (json["events_as_treasurer"] ?? []) +
            (json["events_as_volunteer"] ?? []);
}

class KuttyUser {
  KuttyUser({name, email, department, id});
  late String name;
  late String email;
  late String role;
  late String sessionId;
  late String id;
  late List<dynamic> myEvents = [];

  KuttyUser.fromJSON(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        email = json['email'],
        role = json['type'],
        id = json['_id'];
  // myEvents = jsonDecode(json["events_as_studentcoordinator"]) as List;
}

Future<void> saveCurrentUser(User user) async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  try {
    await storage.write(key: 'user_id', value: user.id);
    await storage.write(key: 'name', value: user.name);
    await storage.write(key: 'email', value: user.email);
    await storage.write(key: 'role', value: user.role);
    await storage.write(key: 'my_events', value: user.myEvents.toString());
  } catch (err) {
    print(err);
  }
}

Future<User> getUser() async {
  FlutterSecureStorage storage = FlutterSecureStorage();
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
  if (response.statusCode == 200) {
    User user = User.fromJSON(jsonDecode(response.body));
    await saveCurrentUser(user);
    return user;
  } else {
    throw Exception(response.body);
  }
}

Future<List<KuttyUser>> getAllVolunteers() async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          "https://event-management-backend.up.railway.app/api/user/get-all-volunteers"),
      headers: {
        'session_token': id ?? '',
      });
  List<KuttyUser> users = [];
  print(response.body);
  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    for (var i = 0; i < parsed.length; i++) {
      KuttyUser x = KuttyUser.fromJSON(parsed[i]);
      users.add(x);
    }
  } else {
    print('I guess we got error');
    print(response.body);
  }
  return users;
}
