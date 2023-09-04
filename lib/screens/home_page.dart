import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.period_list, required this.newest_day, required this.newest_end_day}) : super(key: key);
  final period_list;
  final newest_day;
  final newest_end_day;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime> predict_days = [];
  int left_days = 0;
  int cycle_days = 0;
  void CalDay(DateTime Newest_Date) {
    if (widget.period_list.length ~/ 3 == 1) {
      cycle_days = 28;
      int temp =  int.parse(widget.period_list[2]);
      for (int i = 0; i <= temp; i++) {
        predict_days.add(Newest_Date.add(Duration(days: 28+i)));
      }
    }
    else {
      cycle_days = 0;
      for (int j = 2; j < widget.period_list.length; j = j+3) {
        cycle_days = cycle_days + int.parse(widget.period_list[j]);
      }
      cycle_days = (cycle_days / (int.parse(widget.period_list.length) / 3)).round(); //평균 생리기간
      for (int i = 0; i <= cycle_days; i++) {
        predict_days.add(Newest_Date.add(Duration(days: 28+i)));
      }
    }
    String temp_newest_start = widget.newest_end_day;
    int temp_newest_year =int.parse(temp_newest_start.substring(0,4));
    int temp_newest_mon =int.parse(temp_newest_start.substring(5,7));
    int temp_newest_day =int.parse(temp_newest_start.substring(8,10));
    print(predict_days[0]);
    left_days = predict_days[0].difference(DateTime.utc(temp_newest_year, temp_newest_mon, temp_newest_day)).inDays;
  }
  @override
  void initState() {
    String temp_newest_start = widget.newest_day;
    int temp_newest_year =int.parse(temp_newest_start.substring(0,4));
    int temp_newest_mon =int.parse(temp_newest_start.substring(5,7));
    int temp_newest_day =int.parse(temp_newest_start.substring(8,10));
    CalDay(DateTime.utc(temp_newest_year, temp_newest_mon, temp_newest_day));
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
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'D-${left_days}',
                            style: TextStyle(
                              fontSize: 32
                            ),
                          ),
                          Divider(thickness: 2,),
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
                      progressColor: const Color(0xFFF48FB1),
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
