import 'package:flutter/material.dart';

const kInputdecoration = InputDecoration(
  hintText: 'Enter your password.',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 218, 210, 255), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 150, 127, 255), width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

const kTitleText = TextStyle(fontSize: 24, fontWeight: FontWeight.w900);
const kSubText = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
