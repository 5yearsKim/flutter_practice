import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//custom
import 'package:myapp/controller.dart';
import 'package:myapp/dbHelper.dart';

class CalendarPage extends StatelessWidget {
  final Controller ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('calendar page'),
        ),
        body: Column(
          children: [
            Container(
              child: MyCalender(),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
                child: ScheduleBox(),
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ))
          ],
        ));
  }
}

class MyCalender extends StatefulWidget {
  @override
  _MyCalenderState createState() => _MyCalenderState();
}

class _MyCalenderState extends State<MyCalender> {
  final Controller ctrl = Get.find();
  final DBHelper dbCtrl = Get.find();

  _MyCalenderState() {
    ctrl.bringCardList();
  }

  var eventDict = {};

  void _onDaySelected(selectedDay, focusedDay) {
    if (!isSameDay(ctrl.selectedDay, selectedDay)) {
      ctrl.setSelectedDay(selectedDay);
    }
  }

  List<dynamic> _getEventsFromDay(DateTime day) {
    final dayFormat = DateFormat('yyyy-MM-dd').format(day);
    var event = ctrl.cardDict[dayFormat];
    // print('event ${formatDay} ${event}');
    return event == null ? [] : [event];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<Controller>(
        builder: (_) => TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: ctrl.selectedDay,
          onDaySelected: _onDaySelected,
          eventLoader: _getEventsFromDay,
          // calendarStyle: CalendarStyle(
          //   isTodayHighlighted: true,
          //   selectedDecoration: BoxDecoration(
          //     color: Colors.blue,
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          //   todayDecoration: BoxDecoration(
          //     color: Colors.purpleAccent,
          //     borderRadius: BorderRadius.circular(10)
          //   ),
          // ),
          selectedDayPredicate: (DateTime date) => isSameDay(date, ctrl.selectedDay),
        ),
      ),
    );
  }
}

class ScheduleBox extends StatelessWidget {
  ScheduleBox({Key? key}) : super(key: key);
  final Controller ctrl = Get.find();
  final DBHelper dbCtrl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: ElevatedButton(
          child: GetBuilder<Controller>(builder: (_) => Text('move to ${ctrl.selectedDay}')),
          onPressed: () async {
            await ctrl.insertCard('test');
            Get.toNamed('/card');
          },
        )),
        Container(child: GetBuilder<Controller>(builder: (_) {
          return ctrl.todayCard == null ? Text('') : Text('${ctrl.todayCard['note']}');
        })),
      ],
    );
  }
}