import 'package:event_manager/models/BillModel.dart';
import 'package:flutter/material.dart';

class BillCard extends StatefulWidget {
  BillCard({super.key, required this.bill});
  BillModel bill;
  @override
  State<BillCard> createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.bill.name),
        Container(
          width: 200,
          height: 200,
          child: Image.network(widget.bill.img),
        ),
      ],
    );
  }
}
