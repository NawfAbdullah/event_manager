import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({super.key, required this.onTap, required this.innerText});
  final Function onTap;
  final String innerText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Text(
          innerText,
          style: kSendButtonTextStyle,
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(32))),
      ),
    );
  }
}
