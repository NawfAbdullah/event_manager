import 'package:event_manager/components/cards/TheCard.dart';
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
    print(event.volunteer);
    for (var i in event.volunteer) {
      x.add({
        'name': i['name'],
        'role': 'volunteer',
      });
    }
    print(x);
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TheCard(
              event.coordinatorName,
              icon: Icons.person_4,
              subText: 'Student Coordinator',
            ),
            event.treasurer != null
                ? Container(
                    width: MediaQuery.of(context).size.width,
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
                        Image.asset(
                          'assets/images/budget.png',
                          width: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.treasurer!.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Text(
                              'Treasurer',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Container(
              height: MediaQuery.of(context).size.height * 0.67,
              child: ListView.builder(
                itemCount: x.length,
                itemBuilder: (context, index) {
                  try {
                    if (x.isNotEmpty) {
                      return Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              Image.asset(
                                x[index]['role'] == 'volunteer'
                                    ? 'assets/images/branch.png'
                                    : 'assets/images/risk.png',
                                width: 40,
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
                    return Text(e.toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/budget" title="budget icons">Budget icons created by Freepik - Flaticon</a>