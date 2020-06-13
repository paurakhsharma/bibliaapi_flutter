import 'package:flutter/material.dart';

class Bible {
  String bible;
  String title;

  Bible({@required this.bible, @required this.title});

  factory Bible.fromJSON(json) {
    return Bible(
      bible: json['bible'] as String,
      title: json['title'] as String,
    );
  }
}
