import 'package:event_manager/components/SubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({
    super.key,
    required this.eventId,
    required this.subEventId,
  });
  final String eventId;
  final String subEventId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "You don't have access",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            'assets/images/request.svg',
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          SubmitButton(onTap: () {}, innerText: 'Request')
        ],
      ),
    );
  }
}
