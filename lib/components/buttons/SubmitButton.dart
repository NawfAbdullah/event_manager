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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: const BoxDecoration(
            color: Color(0xff92a95f),
            borderRadius: BorderRadius.all(Radius.circular(32))),
        child: Text(
          innerText,
          style: kSendButtonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
