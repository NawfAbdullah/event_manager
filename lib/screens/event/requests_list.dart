import 'package:event_manager/components/cards/RequestCard.dart';
import 'package:event_manager/models/RequestModel.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  RequestList({super.key, required this.eventId});
  final String eventId;
  late final Future<List<RequestModel>> requests = getAllRequests(eventId);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff92a95f),
      child: FutureBuilder(
        future: requests,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print('bulu bulu bulu');
                print(snapshot.data);
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.isEmpty) {
                      return const Text('No pending requests');
                    } else {
                      return RequestCard(
                          requestModel: snapshot.data?[index] ??
                              RequestModel(
                                  id: '',
                                  requestedBy: '',
                                  forEvent: '',
                                  toSubEvent: '',
                                  position: '',
                                  status: '',
                                  requestedOn: DateTime.now(),
                                  profile: null));
                    }
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
          }
        },
      ),
    );
  }
}
