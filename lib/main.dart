import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../screens/home_page.dart';
import '../screens/loading_page.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Diary App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoadingPage(),
    );
  }
}