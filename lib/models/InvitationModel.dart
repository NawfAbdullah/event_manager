import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class InvitationModel {
  InvitationModel({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.postion,
    required this.status,
    required this.onDate,
  });
  final String id;
  final String eventName;
  final String eventId;
  final String postion;
  String status;
  final DateTime onDate;

  InvitationModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        eventName = json['from_event']['name'],
        eventId = json['from_event']['_id'],
        postion = json['position'],
        status = json['status'],
        onDate = DateTime.parse(json['invitation_made_date']);
}

//{_id: 66149504fd5e9ba98f1cf9f4, invitation_to: {_id: 66143972fd5e9ba98f1cf886, type: volunteer, email: volun2@gmail.com, name: Fateen, profile: null}, from_event: {_id: 66148b06fd5e9ba98f1cf912, name: Archane}, from_sub_event: null, position: treasurer, status: waiting, invitation_made_date: 2024-04-08T17:28:26.829Z, invitation_response_date: null}

Future<List<InvitationModel>> getAllInvitation() async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          "https://event-management-backend.up.railway.app/api/invitation/get-all-user"),
      headers: {
        'session_token': id ?? '',
      });
  List<InvitationModel> invitations = [];
  if (response.statusCode == 200) {
    final parsedJson = jsonDecode(response.body);
    print(parsedJson);
    for (var i in parsedJson) {
      InvitationModel x = InvitationModel.fromJson(i);
      if (x.status == "waiting") {
        invitations.add(x);
      }
    }
  } else {
    return [];
  }

  return invitations;
}

// {
//         "_id": "65fd7859cb41d6bc0b3fb0f8",
//         "invitation_to": {
//             "_id": "65f6c40a624d0697ee548873",
//             "type": "volunteer",
//             "email": "volunteer3@gmail.com",
//             "name": "Fateen"
//         },
//         "from_event": {
//             "_id": "65fd75d8cb41d6bc0b3fb075",
//             "name": "Newest Event"
//         },
//         "from_sub_event": null,
//         "position": "treasurer",
//         "status": "waiting",
//         "invitation_made_date": "2024-03-21T18:28:29.860Z",
//         "invitation_response_date": null
//     }