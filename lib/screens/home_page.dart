import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:period_calendar/screens/calendar_page.dart';
import 'package:period_calendar/screens/statistics_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.period_list, required this.newest_day, required this.newest_end_day}) : super(key: key);
  final period_list;
  final newest_day;
  final newest_end_day;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<DateTime> predict_days = [];
  int left_days = 0;
  int cycle_days = 0;
  String possibility = '';
  bool day_check = false;
  List<String> period_list = [];
  var newest_day;
  var newest_end_day;
  int temp = 0;
  void load_data() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      period_list = prefs.getStringList('period')!;
      newest_day = prefs.getString('newest');
      newest_end_day = prefs.getString('newest_end');
      cycle_days = prefs.getInt('cycle_days')!;
    });
  }

  void CalPossible() {
    if (left_days <= 16 && left_days >= 14) {
      possibility = '높음';
    }
    else if (left_days <= 20 && left_days >= 9) {
      possibility = '보통';
    }
    else {
      possibility = '낮음';
    }
    if (left_days <= 19 && left_days >= 11) {
      day_check = true;
    }
  }
  void CalDay(DateTime Newest_Date) {
    if (widget.period_list.length == 3) {
      cycle_days = 28;
      temp = int.parse(widget.period_list[2]);
      int temp_range =  int.parse(widget.period_list[2]);
      for (int i = 0; i <= temp_range; i++) {
        predict_days.add(Newest_Date.add(Duration(days: 28+i)));
      }
    }
    else {
      cycle_days = 0;
      temp = 0;
      print(widget.period_list);
      for (int j = 2; j < widget.period_list.length; j = j+3) {
        print(widget.period_list[j]);
        temp = temp + int.parse(widget.period_list[j]);
      }
      temp = (temp / (widget.period_list.length ~/ 3)).round(); //평균 생리기간
      //print('temp =  ${temp}');
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
      for (int i = 0; i <= temp; i++) {
        predict_days.add(Newest_Date.add(Duration(days: cycle_days+i)));
      }
      print('생리 지속일 : ${cycle_days}');
      print('생리 다음 주기 : ${temp}');
    }
    String temp_newest_start = widget.newest_end_day;
    int temp_newest_year =int.parse(temp_newest_start.substring(0,4));
    int temp_newest_mon =int.parse(temp_newest_start.substring(5,7));
    int temp_newest_day =int.parse(temp_newest_start.substring(8,10));
    left_days = predict_days[0].difference(DateTime.now()).inDays;
  }
  @override
  void initState() {
    print('this is ok');
    String temp_newest_start = widget.newest_day;
    int temp_newest_year =int.parse(temp_newest_start.substring(0,4));
    int temp_newest_mon =int.parse(temp_newest_start.substring(5,7));
    int temp_newest_day =int.parse(temp_newest_start.substring(8,10));
    load_data();
    CalDay(DateTime.utc(temp_newest_year, temp_newest_mon, temp_newest_day));
    CalPossible();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Container(
                    child: CircularPercentIndicator(
                      radius: MediaQuery.of(context).size.width*0.25,
                      lineWidth: 6.0,
                      percent: (cycle_days-left_days)/cycle_days,
                      center: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'D-${left_days}',
                              style: TextStyle(
                                fontSize: 32
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Text(
                              '다음 생리일',
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              DateFormat('yyyy.MM.dd').format(predict_days[0]),
                              style: TextStyle(
                                  fontSize: 14
                              ),
                            ),
                          ],
                        ),
                      ),
                      progressColor: const Color(0xFFF48FB1),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.47-15,
                          child: Column(
                            children: [
                              Text(
                                '임신확률',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                possibility,
                                style: TextStyle(
                                  fontSize: 24
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          child: VerticalDivider(thickness: 2,)
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width*0.47-15,
                          child: Center(
                            child: Text(
                              day_check == true ? '가임기' : '비가임기',
                              style: TextStyle(
                                  fontSize: 24
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
            if(index == 1){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CalendarPage(
                period_list: widget.period_list, newest_day: widget.newest_day, newest_end_day: widget.newest_end_day,
              )), (route) => false);
            }
            if(index == 2){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Stats_page(
                period_list: widget.period_list, newest_day: widget.newest_day, newest_end_day: widget.newest_end_day,
              )), (route) => false);
            }
            if(index == 3){

            }
          });
        },
      ),
    );
  }
}
