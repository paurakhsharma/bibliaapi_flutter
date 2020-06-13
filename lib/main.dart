import 'package:flutter/material.dart';
import 'package:onesheep_test/provider/bible_notifier.dart';
import 'package:onesheep_test/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BibleNotifier(),
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xffFF2374),
        accentColor: Color(0xff484556),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    ),
    );
  }
}
