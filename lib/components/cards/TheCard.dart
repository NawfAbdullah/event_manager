import 'package:event_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class TheCard extends StatelessWidget {
  TheCard(this.text, {super.key, required this.icon, required this.subText});
  IconData icon;
  String text;
  String subText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.11,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          color: Color(0xffE8F4D0),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.green)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subText,
                style: kSubText.copyWith(color: Colors.blueGrey),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    color: const Color(0xff92a95f),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
