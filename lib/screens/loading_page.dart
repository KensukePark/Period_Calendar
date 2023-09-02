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
  DateTime date = DateTime.now();
  void checkData() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? check = prefs.getBool('check');
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
            content: SingleChildScrollView(child:new Text("가장 최근 생리일을 입력해주세요.")),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (selectedDate != null) {
                    setState(() {
                      date = selectedDate;
                    });
                  }
                  if (selectedDate == null) {
                    exit(0);
                  }
                  else {
                    prefs.setBool('check', true);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomePage()), (route) => false);
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