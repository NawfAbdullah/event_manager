import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class RequestModel {
  final String id;
  final String requestedBy;
  final String forEvent;
  final String toSubEvent;
  final String position;
  final String? profile;
  String status;
  final DateTime requestedOn;
  RequestModel(
      {required this.id,
      required this.requestedBy,
      required this.forEvent,
      required this.toSubEvent,
      required this.position,
      required this.status,
      required this.requestedOn,
      required this.profile});

  RequestModel.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        requestedBy = json['request_by']?['name'] ?? '',
        forEvent = json['to_event']?["name"] ?? '',
        toSubEvent = json['to_sub_event']?["name"] ?? '',
        position = json["position"],
        status = json["status"],
        requestedOn = DateTime.parse(
          json["request_made_date"],
        ),
        profile = json['request_by']?['profile'];
}

Future<List<RequestModel>> getAllRequests(String eventId) async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  print('EEEEEEEEEEEEEEEEEEEEEEEEvvvvvvvvvvvvvvvvvennntIIIIIIIIIIDDDDDDD');
  print(eventId);
  final response = await get(
      Uri.parse(
        'https://event-management-backend.up.railway.app/api/request/get-all-event?event_id=${eventId}',
      ),
      headers: {'session_token': id ?? ''});
  if (response.statusCode == 200) {
    final parsedJson = jsonDecode(response.body);

    List<RequestModel> requestList = [];
    for (var i = 0; i < parsedJson.length; i++) {
      try {
        RequestModel requestModel = RequestModel.fromJSON(parsedJson[i]);
        requestList.add(requestModel);
      } catch (e) {
        print('error is here i guess');
        print(e);
      }
    }
    return requestList;
  } else {
    print('idhu inga');
    print(response.body);
    return [];
  }
}

Future<List<RequestModel>> getMyRequests() async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
        'https://event-management-backend.up.railway.app/api/request/get-all',
      ),
      headers: {'session_token': id ?? ''});
  if (response.statusCode == 200) {
    final parsedJson = jsonDecode(response.body);

    List<RequestModel> requestList = [];
    for (var i = 0; i < parsedJson.length; i++) {
      try {
        RequestModel requestModel = RequestModel.fromJSON(parsedJson[i]);
        requestList.add(requestModel);
      } catch (e) {
        print('error is here i guess');
        print(e);
      }
    }
    return requestList;
  } else {
    print('idhu inga');
    print(response.body);
    return [];
  }
}

//  {
//         "_id": "65f698c259cfbe3d9e23b4d8",
//         "request_by": {
//             "_id": "65f5a96459cfbe3d9e23b294",
//             "type": "volunteer",
//             "email": "volunteer2@gmail.com",
//             "name": "Volunteer 2"
//         },
//         "to_event": {
//             "_id": "65edc1bf02a2259076846038",
//             "name": "Becrez"
//         },
//         "to_sub_event": {
//             "_id": "65f4dae659cfbe3d9e23adaf",
//             "name": "Shakir"
//         },
//         "position": "eventmanager",
//         "status": "waiting",
//         "request_made_date": "2024-03-15T21:06:45.586Z",
//         "request_response_date": null
//     }
