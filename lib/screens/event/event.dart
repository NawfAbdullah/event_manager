import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  Event({super.key, required this.EventId, required this.EventName});
  final String EventId;
  final String EventName;
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  late List<Widget> screens;
  int curr_index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = [
      Container(
        child: Text(widget.EventName),
      ),
      Placeholder(),
      Placeholder(),
      Placeholder(),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.EventName),
      ),
      body: screens[curr_index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curr_index,
          selectedItemColor: Color.fromARGB(255, 121, 94, 217),
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            setState(() {
              curr_index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.event), label: 'Sub Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_sharp),
                label: 'organizers'),
            BottomNavigationBarItem(
                icon: Icon(Icons.subscript), label: 'Bills'),
            BottomNavigationBarItem(
                icon: Icon(Icons.insights), label: 'Insights'),
          ]),
    );
  }
}
