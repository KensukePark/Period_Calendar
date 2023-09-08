import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import 'calendar_page.dart';
import 'home_page.dart';

class Stats_page extends StatefulWidget {
  const Stats_page({Key? key, required this.period_list, required this.newest_day, required this.newest_end_day}) : super(key: key);
  final period_list;
  final newest_day;
  final newest_end_day;

  @override
  State<Stats_page> createState() => _Stats_page();
}

class _Stats_page extends State<Stats_page> {
  bool extended = false;
  int _currentIndex = 2;
  late DateTime date;
  List<String> period_list = [];
  var newest_day;
  var newest_end_day;
  int cycle_means = 0;
  DateTime date_start = DateTime.now();
  DateTime date_end = DateTime.now();
  var diff;
  var target_day;
  var compare_day;
  int cycle_days = 0;
  int dur_days = 0;
  void load_data() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      period_list = prefs.getStringList('period')!;
      newest_day = prefs.getString('newest')!;
      newest_end_day = prefs.getString('newest_end')!;
      cycle_means = prefs.getInt('cycle_days')!;
    });
  }

  void CalDay() {
    if (widget.period_list.length == 3) {
      cycle_days = 28;
      dur_days = int.parse(widget.period_list[2]);
    }
    else {
      for (int j = 2; j < widget.period_list.length; j = j + 3) {
        dur_days = dur_days + int.parse(widget.period_list[j]);
      }
      dur_days =
          (dur_days / ((widget.period_list.length ~/ 3) - 1)).round(); //평균 생리기간

      print('cycle days calcul result : ${cycle_days}');
      for (int k = 0; k < widget.period_list.length ~/ 3 - 1; k++) {
        cycle_days = cycle_days + DateTime.utc(
            int.parse(widget.period_list[3*k].substring(0,4)),
            int.parse(widget.period_list[3*k].substring(5,7)),
            int.parse(widget.period_list[3*k].substring(8,10))
        ).difference(
            DateTime.utc(
                int.parse(widget.period_list[3*(k+1)].substring(0,4)),
                int.parse(widget.period_list[3*(k+1)].substring(5,7)),
                int.parse(widget.period_list[3*(k+1)].substring(8,10))
            )
        ).inDays;
      }
      cycle_days = (cycle_days / (widget.period_list.length ~/ 3 - 1)).round();
    }
  }


  void addData() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear(); //테스트용 생리 기록 초기화
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '데이터를 추가합니다..',
            style: TextStyle(fontSize: 16,),
          ),
          content: SingleChildScrollView(child:new Text("시작일과 종료일을 입력해주세요.")),
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
                  Navigator.pop(context, true);
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
                    Navigator.pop(context, true);
                  }
                  else {
                    print(date_start.toString().substring(0,10));
                    print(date_end.toString().substring(0,10));
                    var diff = date_end.difference(date_start);
                    print(diff.inDays);
                    period_list.add(DateFormat('yyyy-MM-dd').format(date_start));
                    period_list.add(DateFormat('yyyy-MM-dd').format(date_end));
                    period_list.add((diff.inDays+1).toString());
                    //sort_period();
                    prefs.setStringList('period', period_list);
                    prefs.setInt('num', 1);
                    period_list = prefs.getStringList('period')!;
                    newest_day = prefs.getString('newest')!;
                    newest_end_day = prefs.getString('newest_end')!;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Stats_page(period_list: period_list, newest_day: newest_day, newest_end_day: newest_end_day,)), (route) => false);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
  void sort_period() {
    period_list = widget.period_list;
    newest_end_day = widget.newest_end_day;
    newest_day = widget.newest_day;
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
  @override
  void initState() {
    period_list = widget.period_list;
    newest_day = widget.newest_day;
    newest_end_day = widget.newest_end_day;
    CalDay();
    load_data();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Calendar'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.1,
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.period_list.length ~/ 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '  •  ' + period_list[3*index] + ' ~ ' + period_list[3*index+1],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Stack(
                              children: [
                                LinearPercentIndicator( //다음 생리까지 소요일 막대바
                                  width: index == 0 ? (cycle_days <= 35 ? MediaQuery.of(context).size.width * 0.20 * (cycle_days / 8) :
                                  MediaQuery.of(context).size.width - 30 ) : (
                                      DateTime.utc(
                                          int.parse(period_list[3*(index-1)].substring(0,4)),
                                          int.parse(period_list[3*(index-1)].substring(5,7)),
                                          int.parse(period_list[3*(index-1)].substring(8,10))
                                      ).difference(
                                          DateTime.utc(
                                              int.parse(period_list[3*(index)].substring(0,4)),
                                              int.parse(period_list[3*(index)].substring(5,7)),
                                              int.parse(period_list[3*(index)].substring(8,10))
                                          )
                                      ).inDays <= 35 ?

                                  (MediaQuery.of(context).size.width) * 0.2 * (
                                      DateTime.utc(
                                          int.parse(period_list[3*(index-1)].substring(0,4)),
                                          int.parse(period_list[3*(index-1)].substring(5,7)),
                                          int.parse(period_list[3*(index-1)].substring(8,10))
                                      ).difference(
                                          DateTime.utc(
                                              int.parse(period_list[3*(index)].substring(0,4)),
                                              int.parse(period_list[3*(index)].substring(5,7)),
                                              int.parse(period_list[3*(index)].substring(8,10))
                                          )
                                      ).inDays / 8) : MediaQuery.of(context).size.width - 30 ),
                                  percent: 1,
                                  lineHeight: 20.0,
                                  barRadius: Radius.circular(10),
                                  progressColor: Colors.grey,
                                ),
                                LinearPercentIndicator( //생리 기간 막대바
                                  width: MediaQuery.of(context).size.width * 0.20,
                                  percent: 1,
                                  lineHeight: 20.0,
                                  barRadius: Radius.circular(10),
                                  progressColor: const Color(0xFFF48FB1),
                                ),
                                Container( //생리 기간 텍스트
                                  width: MediaQuery.of(context).size.width * 0.20,
                                  child: Center(
                                    child: Text(
                                      period_list[3*index+2],
                                    ),
                                  ),
                                ),
                                Container( //다음 생리까지 소요일 텍스트
                                  width: (index == 0 ? (cycle_days <= 35 ?
                                  MediaQuery.of(context).size.width * 0.20 * (cycle_days / 8) + MediaQuery.of(context).size.width * 0.10 :
                                  MediaQuery.of(context).size.width
                                  ) : (
                                      DateTime.utc(
                                          int.parse(period_list[3*(index-1)].substring(0,4)),
                                          int.parse(period_list[3*(index-1)].substring(5,7)),
                                          int.parse(period_list[3*(index-1)].substring(8,10))
                                      ).difference(
                                          DateTime.utc(
                                              int.parse(period_list[3*(index)].substring(0,4)),
                                              int.parse(period_list[3*(index)].substring(5,7)),
                                              int.parse(period_list[3*(index)].substring(8,10))
                                          )
                                      ).inDays <= 35 ?
                                  (MediaQuery.of(context).size.width) * 0.20 * (
                                      DateTime.utc(
                                          int.parse(period_list[3*(index-1)].substring(0,4)),
                                          int.parse(period_list[3*(index-1)].substring(5,7)),
                                          int.parse(period_list[3*(index-1)].substring(8,10))
                                      ).difference(
                                          DateTime.utc(
                                              int.parse(period_list[3*(index)].substring(0,4)),
                                              int.parse(period_list[3*(index)].substring(5,7)),
                                              int.parse(period_list[3*(index)].substring(8,10))
                                          )
                                      ).inDays / 8 ) + MediaQuery.of(context).size.width * 0.10 : MediaQuery.of(context).size.width - 30
                                  )
                                  ),
                                  child: Center(
                                    child: Text(
                                      index == 0 ? cycle_days.toString() :
                                      DateTime.utc(
                                          int.parse(period_list[3*(index-1)].substring(0,4)),
                                          int.parse(period_list[3*(index-1)].substring(5,7)),
                                          int.parse(period_list[3*(index-1)].substring(8,10))
                                      ).difference(
                                          DateTime.utc(
                                              int.parse(period_list[3*(index)].substring(0,4)),
                                              int.parse(period_list[3*(index)].substring(5,7)),
                                              int.parse(period_list[3*(index)].substring(8,10))
                                          )
                                      ).inDays.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: const Color(0xFFF48FB1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 14),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 1 ? Icons.calendar_month : Icons.calendar_month_outlined), label: '달력'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined), label: '통계'),
          BottomNavigationBarItem(icon: Icon(_currentIndex == 3 ? Icons.settings : Icons.settings_outlined), label: '설정'),
        ],
        onTap: (int index){
          setState(() {
            _currentIndex = index;
            if(index == 0){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(
                period_list: widget.period_list, newest_day: widget.newest_day, newest_end_day: widget.newest_end_day,
              )), (route) => false);
            }
            if(index == 1){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CalendarPage(
                period_list: widget.period_list, newest_day: widget.newest_day, newest_end_day: widget.newest_end_day,
              )), (route) => false);
            }
            if(index == 3){

            }
          });
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: extended ? 120 : 70,
        child: extendButton(),
      ),
    );
  }
  FloatingActionButton extendButton() {
    return FloatingActionButton(
      onPressed: () {
        addData();
      },
      child: const Icon(
        Icons.add,
        size: 30,
      ),

      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFFF48FB1),
    );
  }
}
