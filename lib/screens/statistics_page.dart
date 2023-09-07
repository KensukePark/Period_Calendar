import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var period_list = [];
  var newest_day = '';
  var newest_end_day = '';
  int cycle_means = 0;
  void load_data() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      period_list = prefs.getStringList('period')!;
      newest_day = prefs.getString('newest')!;
      newest_end_day = prefs.getString('newest_end')!;
      cycle_means = prefs.getInt('cycle_days')!;
    });
  }
  @override
  void initState() {
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
                  scrollDirection: Axis.horizontal,
                  itemCount: period_list.length ~/ 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
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
                              LinearPercentIndicator(
                                width: index == 0 ? (MediaQuery.of(context).size.width - 30) * (cycle_means / 35) :
                                (MediaQuery.of(context).size.width - 30) * (
                                    DateTime.utc(
                                        int.parse(period_list[3*index].substring(0,4)),
                                        int.parse(period_list[3*index].substring(5,7)),
                                        int.parse(period_list[3*index].substring(8,10))
                                    ).difference(
                                        DateTime.utc(
                                            int.parse(period_list[3*(index+1)+1].substring(0,4)),
                                            int.parse(period_list[3*(index+1)+1].substring(5,7)),
                                            int.parse(period_list[3*(index+1)+1].substring(8,10))
                                        )
                                    ).inDays / 35),
                                percent: 1,
                                lineHeight: 20.0,
                                barRadius: Radius.circular(10),
                                progressColor: Colors.grey,
                              ),
                              LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width * 0.25,
                                percent: 1,
                                lineHeight: 20.0,
                                barRadius: Radius.circular(10),
                                progressColor: const Color(0xFFF48FB1),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Center(
                                  child: Text(
                                    period_list[3*index+2],
                                  ),
                                ),
                              ),
                              Container(
                                width: index == 0 ? (MediaQuery.of(context).size.width - 30) * (cycle_means / 35) + MediaQuery.of(context).size.width * 0.25:
                                (MediaQuery.of(context).size.width - 30) * (
                                    DateTime.utc(
                                        int.parse(period_list[3*index].substring(0,4)),
                                        int.parse(period_list[3*index].substring(5,7)),
                                        int.parse(period_list[3*index].substring(8,10))
                                    ).difference(
                                        DateTime.utc(
                                            int.parse(period_list[3*(index+1)+1].substring(0,4)),
                                            int.parse(period_list[3*(index+1)+1].substring(5,7)),
                                            int.parse(period_list[3*(index+1)+1].substring(8,10))
                                        )
                                    ).inDays / 35) + MediaQuery.of(context).size.width * 0.25,
                                child: Center(
                                  child: Text(
                                    index == 0 ? cycle_means.toString() :
                                    DateTime.utc(
                                        int.parse(period_list[3*index].substring(0,4)),
                                        int.parse(period_list[3*index].substring(5,7)),
                                        int.parse(period_list[3*index].substring(8,10))
                                    ).difference(
                                        DateTime.utc(
                                            int.parse(period_list[3*(index+1)+1].substring(0,4)),
                                            int.parse(period_list[3*(index+1)+1].substring(5,7)),
                                            int.parse(period_list[3*(index+1)+1].substring(8,10))
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
    return FloatingActionButton.extended(
      onPressed: () {
        setState(() {
          extended = !extended;
        });
      },
      label: const Text("Click"),
      isExtended: extended,
      icon: const Icon(
        Icons.add,
        size: 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      /// 텍스트 컬러
      foregroundColor: Colors.white,
      backgroundColor: Colors.red,
    );
  }
}
