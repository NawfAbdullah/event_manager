import 'package:flutter/material.dart';

const kInputdecoration = InputDecoration(
  hintText: 'Enter your password.',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  labelStyle: TextStyle(color: Color(0xff92a95f)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffC5D99A), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff92a95f), width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

final kCardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(30),
  color: const Color(0xffE8F4D0),
);

const kTitleText = TextStyle(fontSize: 24, fontWeight: FontWeight.w900);
const kSubText = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
