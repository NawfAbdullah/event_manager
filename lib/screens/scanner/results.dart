import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/ParticipantModel.dart';
import 'package:flutter/material.dart';
// import 'package:registration_scanner/constants/constants.dart';
// import 'package:registration_scanner/models/participant_model.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.uuid});
  final uuid;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<Participant> team;

  Future<Participant> fetchScanned() async {
    print("cover");
    return await fetchTeam(widget.uuid);
  }

  @override
  void initState() {
    // TODO: implement initState
    team = fetchTeam(widget.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: team,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasData) {
                  print("xxxxx");
                  print(snapshot.data);
                  return Scaffold(
                    appBar: AppBar(title: Text('Results')),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.check),
                    ),
                    body: ListView(
                      children: [
                        Text(
                          'College: ${snapshot.data?.college}',
                          style: kSubText,
                        ),
                        Text('Event: ${snapshot.data?.eventName}'),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 5,
                          ),
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(5, 5),
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Text(
                                'Name:${snapshot.data?.name}',
                                textAlign: TextAlign.left,
                                style: kSubText,
                              ),
                              Text(
                                "Email: ${snapshot.data?.email}",
                                textAlign: TextAlign.left,
                                style: kSubText,
                              ),
                              Text(
                                "Contact: ${snapshot.data?.contactNo}",
                                textAlign: TextAlign.left,
                                style: kSubText,
                              ),
                              Text(
                                "College: ${snapshot.data?.college}",
                                textAlign: TextAlign.left,
                                style: kSubText,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('Error: ${snapshot.error}');
                }
            }
          }),
    );
  }
}
