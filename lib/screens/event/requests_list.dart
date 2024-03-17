import 'package:event_manager/components/RequestCard.dart';
import 'package:event_manager/models/RequestModel.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  RequestList({super.key, required this.eventId});
  final String eventId;
  late final Future<List<RequestModel>> requests = getAllRequests(eventId);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requests,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              print('bulu bulu bulu');
              print(snapshot.data);
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  if (snapshot.data?.length == 0) {
                    return Text('No pending requests');
                  } else if (snapshot.data?[index].status == "waiting") {
                    return RequestCard(
                        requestModel: snapshot.data?[index] ??
                            RequestModel(
                                id: '',
                                requestedBy: '',
                                forEvent: '',
                                toSubEvent: '',
                                position: '',
                                status: '',
                                requestedOn: DateTime.now()));
                  }
                },
              );
            } else {
              return CircularProgressIndicator();
            }
        }
      },
    );
  }
}
