import 'package:flutter/material.dart';
import 'package:onesheep_test/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xffFF2374),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        font
      ),
      home: HomeScreen(),
    );
  }
}

