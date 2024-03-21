import 'package:event_manager/models/ParticipantModel.dart';
import 'package:flutter/material.dart';

class ParticipantsList extends StatelessWidget {
  ParticipantsList({
    super.key,
    required this.eventId,
    required this.subEventId,
  });
  final String eventId;
  final String subEventId;
  @override
  Widget build(BuildContext context) {
    Future<List<Participant>> participants =
        getAllParticipant(eventId, subEventId);
    return FutureBuilder(
        future: participants,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        });
  }
}
