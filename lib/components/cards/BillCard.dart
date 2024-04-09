import 'dart:convert';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/BillModel.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/participants/participants.dart';
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
  Color back = Color.fromARGB(255, 228, 243, 195);
  String remark = '';
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
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.91,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.bill.name,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Tablet(
                          color: widget.bill.status == 'accepted'
                              ? Colors.green
                              : Colors.redAccent,
                          text: widget.bill.status,
                          icon: Icons.verified)
                    ],
                  ),
                  Text(
                    widget.bill.description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.bill.img,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  id == widget.treasurer?.id && widget.bill.status == "waiting"
                      ? Column(
                          children: [
                            TextField(
                              decoration: kInputdecoration.copyWith(
                                  hintText: '', labelText: 'Remarks'),
                              onChanged: (value) {
                                setState(() {
                                  remark = value;
                                });
                              },
                            ),
                            ButtonBar(
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
                            ),
                          ],
                        )
                      : Text(
                          "Treasurer words : ${widget.bill.remarks}",
                          style: const TextStyle(color: Colors.black),
                        )
                ],
              ),
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
          "message": remark // not-required
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
    }
  }
}
