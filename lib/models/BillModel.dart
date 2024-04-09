import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class BillModel {
  final String billId;
  final String name;
  String status;
  final String img;
  final String description;
  final DateTime uploadedDate;
  String remarks;
  BillModel(
      {required this.billId,
      required this.name,
      required this.status,
      required this.img,
      required this.description,
      required this.uploadedDate,
      required this.remarks});
  BillModel.fromJson(Map<String, dynamic> json)
      : billId = json["_id"],
        img = json["img"],
        name = json["uploaded_by"]["name"],
        description = json["description"],
        status = json["status"],
        uploadedDate = DateTime.parse(json["bill_uploaded_date"]),
        remarks = json['message_from_treasurer'] ?? '';
}

Future<List<BillModel>> getAllBills(String eventId, String subEventId) async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final id = await storage.read(key: 'sessionId');
  final response = await get(
      Uri.parse(
          "https://event-management-backend.up.railway.app/api/bill/get-all?event_id=$eventId&sub_event_id=$subEventId"),
      headers: {
        'session_token': id ?? '',
      });
  List<BillModel> bills = [];
  if (response.statusCode == 200) {
    Map<String, dynamic> parsed = jsonDecode(response.body);
    List unparsed = parsed['bills'] ?? parsed['your_bills'];
    for (var i = 0; i < unparsed.length; i++) {
      try {
        print('ifykyk');
        print(unparsed[i]);
        BillModel x = BillModel.fromJson(unparsed[i]);
        bills.add(x);
      } catch (e) {
        print('ifydkyk');
        print(e);
      }
    }
  } else {
    print('there is a error in bills');
    print(response.body);
  }
  return bills;
}
