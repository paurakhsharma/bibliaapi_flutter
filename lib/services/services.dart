import 'dart:convert';

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
    /**
     * Initialize shared preference,
     * and load required app configs
     */
    await preference.initialize();
    _apiKey = environment['apiKey'];
    _baseUrl = environment['baseUrl'];
    if (_apiKey == null || _baseUrl == null)
      throw Exception('Environment variable not found: Make sure you run "dart tools/env.dart"');
  }

  Bible loadSelectedBible() {
    return preference.getSelectedBible();
  }

  updateSelectedBible(String bible, String title) {
    preference.updateSelectedBible(bible, title);
  }

  String parseVerse(String verse) {
    // Remove blank spaces and replace : with .
    // e.g if the input is 1 John 1:2 output will be 1John1.2
    return verse.replaceAll(' ', '').replaceAll(":", '.');
  }

  Future<String> getVerse(String verse, String bible) async {
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

  Future<List> search(String searchParam, String book) async {
    // First check if the search parameter matches any verse
    String formattedVerse = parseVerse(searchParam);
    var url = '$_baseUrl/parse?passage=$formattedVerse&key=$_apiKey';
    var response = await client.get(url);
    var passage = json.decode(response.body)['passage'];
    if (passage != '') {
      // if search param matches the verse return the matched verse
      var verse = await getVerse(formattedVerse, book);
      return [
        {'title': passage, 'preview': verse}
      ];
    }
    // If the search param doesn't match any verse,
    // Make a passage query search.
    var searchUrl = Uri.encodeFull(
        '$_baseUrl/search/$book.js?query=$searchParam&start=0&limit=20&sort=passage&key=$_apiKey');
    var searchResponse = await client.get(searchUrl);
    var results = json.decode(searchResponse.body)['results'];
    return results;
  }

  Future<List> getVerseOfTheDay(bible) async {
    var newVerse = await preference.getTodayVerse();
    var verseText = await getVerse(newVerse, bible);
    if (verseText == null) {
      // if the new verse (i.e. last verse + 1) doesn't exists
      // Find the new chapter (i.e last chapter + 1)
      var verseList = preference.verseStringToList(newVerse);
      var book = verseList[0] == null ? verseList[1] : '${verseList[0]} ${verseList[1]}';
      var chapter = verseList[2];
      var newChapter = '$book ${int.parse(chapter) + 1}';
      List chapters = await getChaptersFromBook(bible, book);
      var newChapterFound =
          chapters.firstWhere((element) => element['passage'] == newChapter, orElse: () => null);
      if (newChapterFound != null) {
        // if the new chapter is found
        // save the new verse in the shared preference
        // and return the verse text
        newVerse = "${newChapterFound['passage']}:1";
        preference.updateSharedPreferenceVerse(newVerse);
        verseText = await getVerse(newVerse, bible);
      } else {
        // if the new chapter is not found
        // Go to the new book
        int currentIndex = _books.indexWhere((element) => element['passage'] == book);
        // if this was the last book, set the index to the first book
        int newBookIndex = currentIndex + 1 == _books.length ? 0 : currentIndex + 1;
        var newBook = _books[newBookIndex]['passage'];
        newVerse = "$newBook 1:1";
        preference.updateSharedPreferenceVerse(newVerse);
        verseText = await getVerse(newVerse, bible);
      }
    }
    return [newVerse, verseText];
  }

  Future<List<Map>> getChaptersFromBook(String bible, String book) async {
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
