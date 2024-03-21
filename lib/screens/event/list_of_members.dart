import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';

class ListOfMembers extends StatelessWidget {
  ListOfMembers({super.key, required this.event});
  EventModel event;
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> x = [];
    for (var i = 0; i < event.subevents.length; i++) {
      if (event.subevents[i].eventManager.length > 1) {
        x.add(
            {'name': event.subevents[i].eventManager, 'role': 'event manager'});
      }
    }
    for (var i in event.volunteer) {
      x.add({
        'name': i['name'],
        'role': 'volunteer',
      });
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.coordinatorName,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          const Text(
            'Student Coordinator',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: x.length,
              itemBuilder: (context, index) {
                try {
                  if (event.volunteer.isNotEmpty) {
                    return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 247, 232, 232),
                                offset: Offset(5, 5),
                                spreadRadius: 10,
                                blurRadius: 10,
                              )
                            ]),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 95,
                              decoration: const BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              padding: const EdgeInsets.all(10),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  x[index]['name'] ?? '',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  x[index]['role'] ?? '',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ));
                  } else {
                    const Text('No volunteers yet');
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
