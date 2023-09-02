import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPage createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
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
            SizedBox(height: 15,),
            SpinKitFadingCircle(
              color: Colors.pinkAccent,
              size: 64.0,
            ),
          ],
        ),
      ),
    );
  }
}