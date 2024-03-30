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
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10),
                                tileColor: Colors.white,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data![index].name,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color:
                                            Color.fromARGB(255, 136, 121, 242),
                                      ),
                                    ),
                                    snapshot.data![index].isVerified
                                        ? Tablet(
                                            color: const Color.fromARGB(
                                                255, 30, 219, 128),
                                            icon: Icons.verified,
                                            text: 'Verified',
                                          )
                                        : Tablet(
                                            color: Colors.redAccent,
                                            text: "pending",
                                            icon: Icons.stop_circle),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.email,
                                          color: Color.fromARGB(
                                              255, 138, 134, 134),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].email,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 138, 134, 134),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color: Color.fromARGB(
                                              255, 138, 134, 134),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].contactNo,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 138, 134, 134),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_city,
                                          color: Color.fromARGB(
                                              255, 138, 134, 134),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].college,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 138, 134, 134),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
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

class Tablet extends StatelessWidget {
  Tablet({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });
  Color color;
  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
              ),
            )
          ]),
    );
  }
}
