import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class Participant {
  late String name;
  late String email;
  late String college;
  late String contactNo;
  late String eventName;

  Participant({
    required name,
    required college,
    required email,
    required contactNo,
    required eventName,
  });

  Participant.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        college = json['college'],
        contactNo = json['contact_no'],
        eventName = json['event_details']['event_name'],
        email = json['email'];
}

Future<Participant> fetchTeam(String uuid) async {
  print("Access");
  final storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  print('yyyyyyyyyyyyyyyyyyyyyyyyyy,$id');
  Map<String, dynamic> jsonObj = jsonDecode(uuid);
  final response = await post(
      Uri.parse(
        'https://event-management-backend.up.railway.app/api/participant/get/',
      ),
      body: jsonEncode({
        "event_id": jsonObj['event_id'].toString(),
        "sub_event_id": jsonObj['sub_event_id'].toString(),
        "participant_id": jsonObj['participant_id'].toString()
      }),
      headers: {
        'session_token': id ?? '',
        'Content-Type': 'application/json',
      });
  print("Done");
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    print('got response');
    Participant x =
        Participant.fromJSON(jsonDecode(response.body) as Map<String, dynamic>);
    return x;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print("ERRRRRRRRORRRRRRR");
    throw Exception('Failed to load user');
  }
}

// Future<List<Participant>> getEventParticipant(String eventName) async {
//   final response = await get(
//       Uri.parse(
//         "https://build-club-backend-production.up.railway.app/individual/$eventName/get-all",
//       ),
//       headers: {
//         'admin-access-code': '5cf80735-886f-4467-ad59-1be691443a1e',
//         'Content-Type': 'application/json',
//       });
//   print("Done");
//   print(response.statusCode);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print('got response');
//     // var x = (jsonDecode(response.body) as List)
//     //     .map((e) {
//     //       print(e);
//     //       return Participant.fromJSON(e);
//     //     } as Map<String, dynamic>)
//     //     .toList();
//     // Participant.fromJSON(jsonDecode(response.body) as Map<String, dynamic>);
//     List x = jsonDecode(response.body);
//     print(x[0]);
//     print('printed x');
//     List<Participant> temp = [];
//     for (var element in x) {
//       Participant newPart = Participant.fromJSON(element);
//       print(newPart);
//       print('printed new partic');
//       temp.add(newPart);
//     }
//     return temp;
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     print("ERRRRRRRRORRRRRRR");
//     throw Exception('Failed to load user');
//   }
// }
