import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({
    super.key,
    required onTap,
  });
  late Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Container(
        child: Text(
          'Log In',
          style: kSendButtonTextStyle,
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(32))),
      ),
    );
  }
}
