import 'dart:convert';
import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
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
  TextEditingController _controller = TextEditingController();
  String name = '';
  String department = '';
  String start = '';
  String end = '';
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) => setState(() {
            name = value;
          }),
          decoration:
              kInputdecoration.copyWith(labelText: 'Event Name', hintText: ''),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          onChanged: (value) => setState(() {
            department = value;
          }),
          decoration:
              kInputdecoration.copyWith(labelText: 'Department', hintText: ''),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _controller,
          decoration: kInputdecoration.copyWith(
            prefixIcon: Icon(Icons.calendar_month_rounded),
            labelText: 'Select date',
            hintText: '',
          ),
          onTap: _selectDate,
          readOnly: true,
        ),
        SizedBox(
          height: 5,
        ),
        SubmitButton(
          onTap: () async {
            final id = await storage.read(key: "sessionId");
            final response = await post(
                Uri.parse(
                  "https://event-management-backend.up.railway.app/api/event/create",
                ),
                body: jsonEncode({
                  "name": name,
                  "date_from": start,
                  "date_to": end,
                  "department": department
                }),
                headers: {
                  "Content-Type": "application/json",
                  "session_token": id ?? ''
                });
            if (response.statusCode == 200) {
              print(response.body);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) =>
              //         Event(EventId: '1234', EventName: 'Becrez')));
            } else {
              print(response.body);
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
