import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:onesheep_test/services/services.dart';

void main() {
  final bibleService = BibleService();
  group("Test getVerse", () {
    test("getVerse returns verse on correct verse and bible name", () async {
      var verseText = 'For God so loved the world, that he gave his only begotten...';
      //setup the test
      bibleService.client = MockClient((request) async {
        final mapJson = {'text': verseText};
        return Response(json.encode(mapJson), 200);
      });

      final item = await bibleService.getVerse('John 3:16', 'KJV');
      expect(item, verseText);
    });
  });
}
