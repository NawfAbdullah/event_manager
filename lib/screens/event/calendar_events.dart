import 'package:event_manager/components/cards/EventCard.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';

class CalendarEvent extends StatefulWidget {
  const CalendarEvent({super.key});

  @override
  State<CalendarEvent> createState() => _CalendarEventState();
}

class _CalendarEventState extends State<CalendarEvent> {
  bool isLoading = false;
  List<EventModel> events = [];

  Future<void> changeEvent(DateTime? date) async {
    setState(() {
      isLoading = true;
    });
    List<EventModel> x = await fetchDayEvents(date ?? DateTime.now());
    setState(() {
      events = x;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (value) async {
                await changeEvent(value);
              },
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : events.isEmpty
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/images/empty.png',
                          width: 100,
                        ),
                        const Center(
                          child: Text(
                            'No Event Available on the day',
                            style: kSubText,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return EventCard(eventModel: events[index]);
                        },
                      ),
                    )
        ],
      ),
    );
  }
}
//<a href="https://www.flaticon.com/free-icons/time-and-date" title="time and date icons">Time and date icons created by Vector Bazar - Flaticon</a>s