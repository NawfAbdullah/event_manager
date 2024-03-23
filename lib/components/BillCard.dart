import 'dart:convert';
import 'package:event_manager/models/BillModel.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class BillCard extends StatefulWidget {
  BillCard({
    super.key,
    required this.bill,
    required this.treasurer,
    required this.eventId,
    required this.subEventId,
  });
  BillModel bill;
  String eventId;
  String subEventId;
  User? treasurer;

  @override
  State<BillCard> createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLoading = false;
  String id = '';
  Color back = Colors.white;
  Future<void> setId() async {
    String? userId = await storage.read(key: 'user_id');
    setState(() {
      id = userId ?? '';
    });
  }

  @override
  void initState() {
    setId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: back,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 10,
            ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bill.name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text(
                  widget.bill.description,
                  textAlign: TextAlign.left,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: Image.network(
                    widget.bill.img,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                id == widget.treasurer?.id && widget.bill.status == "waiting"
                    ? ButtonBar(
                        children: [
                          TextButton.icon(
                            onPressed: () => respond("accepted"),
                            icon: const Icon(Icons.approval),
                            label: Text('Approve'),
                          ),
                          TextButton.icon(
                              onPressed: () => respond("rejected"),
                              icon: const Icon(Icons.cloud_circle_sharp),
                              label: const Text('Deny'))
                        ],
                      )
                    : const SizedBox(
                        height: 5,
                      )
              ],
            ),
    );
  }

  void respond(String status) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    setState(() {
      isLoading = true;
    });
    final session = await secureStorage.read(key: 'sessionId');
    final response = await post(
        Uri.parse(
          'https://event-management-backend.up.railway.app/api/bill/respond-to-bill',
        ),
        body: jsonEncode({
          "event_id": widget.eventId,
          "sub_event_id": widget.subEventId,
          "bill_id": widget.bill.billId,
          "status": status, // accepted or rejected
          "message": "Good one mi amigo" // not-required
        }),
        headers: {
          'content-type': 'application/json',
          'session_token': session ?? ''
        });

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        back = Colors.greenAccent;
        widget.bill.status = status;
      });
    } else {
      setState(() {
        isLoading = false;
        back = Colors.redAccent;
      });
    }
  }
}
