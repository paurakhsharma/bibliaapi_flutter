import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' show Client;
import 'package:onesheep_test/models/bible.dart';
import 'package:onesheep_test/services/preference.dart';
import 'package:onesheep_test/.env.dart';

class BibleService {
  String _apiKey;
  String _baseUrl;
  List _books;
  Preference preference = Preference();
  Client client = Client();

  initialize() async {
    await preference.initialize();
    _apiKey = environment['apiKey'];
    _baseUrl = environment['baseUrl'];
    if (_apiKey == null || _baseUrl == null)
      throw Exception('Environment variable not found: Make sure you run "dart tools/env.dart"');
  }

  Bible loadSelectedBible() {
    return preference.getSelectedBible();
  }

  updateSelectedBible(bible, title) {
    preference.updateSelectedBible(bible, title);
  }

  parseVerse(verse) {
    return verse.replaceAll(' ', '').replaceAll(":", '.');
  }

  Future getVerse(verse, bible) async {
    String formatedVerse = parseVerse(verse);
    var url =
        '$_baseUrl/content/$bible.json?passage=$formatedVerse&style=bibleTextOnly&key=$_apiKey';
    print('url is: $url');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['text'];
    }
    return null;
  }

  Future<List<Bible>> getAllBibles() async {
    var url = '$_baseUrl/find?key=$_apiKey';
    var response = await client.get(url);
    var bibles = json.decode(response.body)['bibles'];
    return bibles.map<Bible>((bible) => Bible.fromJSON(bible)).toList();
  }

  Future search(searchParam, book) async {
    // First check if the search parameter matches any verse
    String formattedVerse = parseVerse(searchParam);
    var url = '$_baseUrl/parse?passage=$formattedVerse&key=$_apiKey';
    print('first url $url');
    var response = await client.get(url);
    var passage = json.decode(response.body)['passage'];
    print('passage is: $passage');
    if (passage != '') {
      // if search param matches the verse return the matched verse
      var verse = await getVerse(formattedVerse, book);
      return [
        {'title': passage, 'preview': verse}
      ];
    }
    var searchUrl = Uri.encodeFull(
        '$_baseUrl/search/$book.js?query=$searchParam&start=0&limit=20&sort=passage&key=$_apiKey');
    print('second url: $searchUrl');
    var searchResponse = await client.get(searchUrl);
    var results = json.decode(searchResponse.body)['results'];
    print('results is $results');
    return results;
  }

  getVerseOfTheDay(bible) async {
    var newVerse = await preference.getTodayVerse();
    var verseText = await getVerse(newVerse, bible);
    if (verseText == null) {
      var verseList = preference.verseStringToList(newVerse);
      var book = verseList[0] == null ? verseList[1] : '${verseList[0]} ${verseList[1]}';
      var chapter = verseList[2];
      var newChapter = '$book ${int.parse(chapter) + 1}';
      List chapters = await getChaptersFromBook(bible, book);
      var newChapterFound = chapters.firstWhere((element) => element['passage'] == newChapter,
          orElse: () => null);
      if (newChapterFound != null) {
        newVerse = "${newChapterFound['passage']}:1";
        preference.updateSharedPreferenceVerse(newVerse);
        verseText = await getVerse(newVerse, bible);
      } else {
        int currentIndex = _books.indexWhere((element) => element['passage'] == book);
        int newBookIndex = currentIndex+1 == _books.length ?  0 : currentIndex + 1;
        var newBook = _books[newBookIndex]['passage'];
        newVerse =  "$newBook 1:1";
        preference.updateSharedPreferenceVerse(newVerse);
        verseText = await getVerse(newVerse, bible);
      }
    }
    print('newVerse: $newVerse');
    print('verseText: $verseText');
    return [newVerse, verseText];
  }

  getChaptersFromBook(bible, book) async {
    List books;
    var url = '$_baseUrl/contents/$bible?key=$_apiKey';
    print('books url: $url');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      books = json.decode(response.body)['books'];
      _books = books;
      var currentBook = books.firstWhere((bookContent) => bookContent['passage'] == book);
      return currentBook['chapters'];
    }
    return null;
  }
}
