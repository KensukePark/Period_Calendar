import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';

class First_add_page extends StatefulWidget {
  @override
  State<First_add_page> createState() => _First_add_page();
}

class _First_add_page extends State<First_add_page> {
  late DateTime date;
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My period calendar222222222',
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
