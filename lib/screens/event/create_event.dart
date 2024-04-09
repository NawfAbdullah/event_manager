import 'dart:convert';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _controller = TextEditingController();
  String name = '';
  String department = '';
  String start = '';
  String end = '';
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool isLoading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              error != null
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(
                      height: 5,
                    ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                onChanged: (value) => setState(() {
                  name = value;
                }),
                decoration: kInputdecoration.copyWith(
                    labelText: 'Event Name', hintText: ''),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) => setState(() {
                  department = value;
                }),
                decoration: kInputdecoration.copyWith(
                    labelText: 'Department', hintText: ''),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _controller,
                decoration: kInputdecoration.copyWith(
                  prefixIcon: const Icon(Icons.calendar_month_rounded),
                  labelText: 'Select date',
                  hintText: '',
                ),
                onTap: _selectDate,
                readOnly: true,
              ),
              const SizedBox(
                height: 5,
              ),
              SubmitButton(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final id = await storage.read(key: "sessionId");
                  final response = await post(
                      Uri.parse(
                        "https://event-management-backend.up.railway.app/api/event/create",
                      ),
                      body: jsonEncode(start == end
                          ? {
                              "name": name,
                              "date_from": start,
                              "department": department,
                              "date_to": null,
                              "img":
                                  "https://images.pexels.com/photos/20732688/pexels-photo-20732688/free-photo-of-man-in-suit-standing-in-lake.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
                            }
                          : {
                              "name": name,
                              "date_from": start,
                              "date_to": end,
                              "department": department,
                              "img":
                                  "https://images.pexels.com/photos/20732688/pexels-photo-20732688/free-photo-of-man-in-suit-standing-in-lake.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
                            }),
                      headers: {
                        "Content-Type": "application/json",
                        "session_token": id ?? ''
                      });
                  if (response.statusCode == 200) {
                    setState(() {
                      isLoading = false;
                    });
                    print(response.body);
                    final parsed = jsonDecode(response.body);
                    EventModel x = EventModel.fromJson(parsed);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Event(eventModel: x)));
                  } else {
                    print(response.body);
                    setState(() {
                      isLoading = false;
                      error = jsonDecode(response.body)['err_msg'];
                    });
                    throw Exception('Something went wrong');
                  }
                },
                innerText: "Add",
              ),
            ],
          );
  }

  Future<void> _selectDate() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        ),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        start =
            "${picked.start.year}-${picked.start.month}-${picked.start.day}";
        end = "${picked.end.year}-${picked.end.month}-${picked.end.day}";
        _controller.text =
            "${start.replaceAll('-', '/')} - ${end.replaceAll('-', '/')}";
      });
    }
  }
}
