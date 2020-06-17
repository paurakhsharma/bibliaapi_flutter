import 'package:flutter/material.dart';

Widget connectioErrorSnackBar() {
  return SnackBar(
    content: Text('Problem connecting to the internet...'),
    duration: Duration(seconds: 2),
  );
}