import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Diary'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(1900, 1, 1),
              lastDay: DateTime.utc(2037, 12, 31),
              focusedDay: focusedDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                setState((){
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (DateTime day) {
                return isSameDay(selectedDay, day);
              },
            ),
          ],
        ),
      ),
    );
  }
}
