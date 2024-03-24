import 'package:event_manager/models/ParticipantModel.dart';
import 'package:flutter/material.dart';

class ParticipantsList extends StatelessWidget {
  const ParticipantsList({
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
                              tileColor: snapshot.data![index].isVerified
                                  ? Colors.greenAccent
                                  : Colors.white,
                              title: Text(
                                snapshot.data![index].name,
                                style: TextStyle(fontSize: 23),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].email,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    snapshot.data![index].contactNo,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    snapshot.data![index].college,
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        });
  }
}
