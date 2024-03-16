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

  User.fromJSON(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        email = json['email'],
        role = json['type'],
        id = json['_id'];
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
    return user;
  } else {
    throw Exception(response.body);
  }
}
