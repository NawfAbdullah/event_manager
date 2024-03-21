import 'package:event_manager/components/BillCard.dart';
import 'package:event_manager/models/BillModel.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  Bills({super.key, required this.subEvent, required this.event});
  SubEventModel subEvent;
  EventModel event;

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  late Future<List<BillModel>> bills;
  @override
  void initState() {
    // TODO: implement initState
    bills = getAllBills(widget.event.id, widget.subEvent.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bills,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              throw Exception(snapshot.error);
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return BillCard(bill: snapshot.data![index]);
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
        }
      },
    );
  }
}
