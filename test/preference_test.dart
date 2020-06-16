import 'package:flutter_test/flutter_test.dart';
import 'package:onesheep_test/services/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Preference preference = Preference();
  group("Test preference", () {
    test("Test getSelectedBible when selected bible is not set", () async {
      SharedPreferences.setMockInitialValues({});
      Preference preference = Preference();
      preference.prefs = await SharedPreferences.getInstance();
      var selectedBible = preference.getSelectedBible();
      expect(selectedBible.bible, 'KJV');
      expect(selectedBible.title, 'King James Version');
    });

    test("Test getSelectedBible when selected bible is set", () async {
      var setBible = ['ASV', 'American Standard Version'];
      SharedPreferences.setMockInitialValues({'selectedBible': setBible});
      preference.prefs = await SharedPreferences.getInstance();
      var selectedBible = preference.getSelectedBible();
      expect(selectedBible.bible, setBible[0]);
      expect(selectedBible.title, setBible[1]);
    });

    test('Test getTodayVerse when the user is opening the app for the first time', () async {
      SharedPreferences.setMockInitialValues({});
      preference.prefs = await SharedPreferences.getInstance();
      var verse = preference.getTodayVerse();
      expect(verse, 'Genesis 1:1');
    });

    test('Test getTodayVerse when the user is opening the app next day', () async {
      final now = DateTime.now();
      final yesterday = new DateTime(now.year, now.month, now.day - 1);
      SharedPreferences.setMockInitialValues(
          {'today': yesterday.toString(), 'verse': 'Genesis 1:1'});
      preference.prefs = await SharedPreferences.getInstance();
      var verse = preference.getTodayVerse();
      expect(verse, 'Genesis 1:2');
    });

    test('Test getNewVerse for book without part', () {
      var newVerse = preference.getNewVerse('Genesis 4:2');
      expect(newVerse, 'Genesis 4:3');
    });

    test('Test getNewVerse for book with part', () {
      var newVerse = preference.getNewVerse('1 John 4:2');
      expect(newVerse, '1 John 4:3');
    });

    test('Test verseStringToList for book without part', () {
      var verseList = preference.verseStringToList('John 1:2');
      expect(verseList[0], null);
      expect(verseList[1], 'John');
      expect(verseList[2], '1');
      expect(verseList[3], '2');
    });

    test('Test verseStringToList for book with part', () {
      var verseList = preference.verseStringToList('1 John 1:2');
      expect(verseList[0], '1 ');
      expect(verseList[1], 'John');
      expect(verseList[2], '1');
      expect(verseList[3], '2');
    });
  });
}
