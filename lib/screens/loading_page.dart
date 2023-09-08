import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:period_calendar/screens/statistics_page.dart';
import 'package:period_calendar/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendar_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage> {
  DateTime date_start = DateTime.now();
  DateTime date_end = DateTime.now();
  var diff;
  var period_list;
  var newest_day;
  var newest_end_day;
  var target_day;
  var compare_day;
  void sort_period() {
    for (int i=0; i<period_list.length-1; i=i+3) {
      int target_idx = i;
      int target_newest_year =int.parse(period_list[i].substring(0,4));
      int target_newest_mon =int.parse(period_list[i].substring(5,7));
      int target_newest_day =int.parse(period_list[i].substring(8,10));
      target_day = int.parse(target_newest_year.toString() + target_newest_mon.toString() + target_newest_day.toString());
      for (int j=i; j<period_list.length; j=j+3) {
        int compare_newest_year =int.parse(period_list[j].substring(0,4));
        int compare_newest_mon =int.parse(period_list[j].substring(5,7));
        int compare_newest_day =int.parse(period_list[j].substring(8,10));
        compare_day = int.parse(compare_newest_year.toString() + compare_newest_mon.toString() + compare_newest_day.toString());
        if (compare_day < target_day) {
          target_idx = j;
        }
      }
      if (i != target_idx) {
        var temp_1 = period_list[i];
        var temp_2 = period_list[i+1];
        var temp_3 = period_list[i+2];
        period_list[i] = period_list[target_idx];
        period_list[i+1] = period_list[target_idx+1];
        period_list[i+2] = period_list[target_idx+2];
        period_list[target_idx] = temp_1;
        period_list[target_idx+1] = temp_2;
        period_list[target_idx+2] = temp_3;
      }
    }
  }
  void checkData() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear(); //테스트용 생리 기록 초기화
    final bool? check = prefs.getBool('check');
    if (check != null) {
      period_list = prefs.getStringList('period');
      newest_day = prefs.getString('newest');
      newest_end_day = prefs.getString('newest_end');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) =>
              HomePage(period_list: period_list, newest_day: newest_day, newest_end_day: newest_end_day,)), (route) => false);
    }
    else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '데이터가 필요합니다.',
              style: TextStyle(fontSize: 16,),
            ),
            content: SingleChildScrollView(child:new Text("가장 최근 생리 시작일과 종료일을 입력해주세요.")),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date_start,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    helpText: '최근 생리 시작일',
                    cancelText: '종료',
                    confirmText: '선택',
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (selectedDate != null) {
                    setState(() {
                      date_start = selectedDate;
                    });
                  }
                  if (selectedDate == null) {
                    exit(0);
                  }
                  else {
                    final selectedDate_end = await showDatePicker(
                      context: context,
                      initialDate: date_start,
                      firstDate: date_start,
                      lastDate: DateTime.now(),
                      helpText: '최근 생리 종료일',
                      cancelText: '종료',
                      confirmText: '선택',
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (selectedDate_end != null) {
                      setState(() {
                        date_end = selectedDate_end;
                      });
                    }
                    if (selectedDate_end == null) {
                      exit(0);
                    }
                    else {
                      print(date_start.toString().substring(0,10));
                      print(date_end.toString().substring(0,10));
                      diff = date_end.difference(date_start);
                      print(diff.inDays);
                      prefs.setStringList('period', [DateFormat('yyyy-MM-dd').format(date_start), DateFormat('yyyy-MM-dd').format(date_end), (diff.inDays+1).toString()]);
                      prefs.setString('newest', DateFormat('yyyy-MM-dd').format(date_start));
                      prefs.setString('newest_end', DateFormat('yyyy-MM-dd').format(date_end));
                      prefs.setBool('check', true);
                      prefs.setInt('num', 1);
                      var period_list = prefs.getStringList('period');
                      var newest_day = prefs.getString('newest');
                      var newest_end_day = prefs.getString('newest_end');
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(period_list: period_list, newest_day: newest_day, newest_end_day: newest_end_day,)), (route) => false);
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
  @override
  void initState() {
    super.initState();
    sleep(Duration(seconds: 2));
    checkData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My period calendar',
              style: TextStyle(
                fontFamily: 'title',
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}