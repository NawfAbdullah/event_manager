import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          decoration: kInputdecoration.copyWith(hintText: 'Event Name'),
        ),
        TextField(
          decoration: kInputdecoration.copyWith(hintText: 'Department'),
        ),
        DatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2024, DateTime.now().month + 1),
        ),
        SubmitButton(onTap: () {
          print('Taped');
        })
      ],
    );
  }
}
