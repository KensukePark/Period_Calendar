import 'dart:io';
import 'package:flutter/material.dart';
import 'package:period_calendar/screens/First_add_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage> {
  DateTime date_start = DateTime.now();
  DateTime date_end = DateTime.now();
  void checkData() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    final bool? check = prefs.getBool('check');
    sleep(Duration(seconds: 2));
    if (check != null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) =>
              HomePage()), (route) => false);
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
                      print(date_start);
                      print(date_end);
                      prefs.setBool('check', true);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage()), (route) => false);
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