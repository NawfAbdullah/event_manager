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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bill.name,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          Text(
            widget.bill.description,
            textAlign: TextAlign.left,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: Image.network(
              widget.bill.img,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
