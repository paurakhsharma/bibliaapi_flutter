import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onesheep_test/models/bible.dart';
import 'package:flutter/services.dart' show rootBundle;

class BibleService {
  String _apiKey;
  String _baseUrl;

  loadConfig() async {
    var configString =  await rootBundle.loadString('config.json');
    final config = json.decode(configString);
    _apiKey = config['api_key'];
    _baseUrl = config['base_url'];
  }

  parseVerse(verse) {
    return verse.replaceAll(' ', '').replaceAll(":", '.');
  }

  Future getVerse(verse, book) async {
    String formatedVerse = parseVerse(verse);
    var url =
        '$_baseUrl/content/$book.json?passage=$formatedVerse&style=bibleTextOnly&key=$_apiKey';
    var response = await http.get(url);
    return json.decode(response.body)['text'];
  }

  Future getAllBibles() async {
    var url = '$_baseUrl/find?key=$_apiKey';
    var response = await http.get(url);
    var bibles = json.decode(response.body)['bibles'];
    return bibles.map<Bible>((bible) => Bible.fromJSON(bible)).toList();
  }

  Future search(searchParam, book) async {
    // First check if the search parameter matches any verse
    String formattedVerse = parseVerse(searchParam);
    var url =
        '$_baseUrl/parse?passage=$formattedVerse&key=$_apiKey';
    print('first url $url');
    var response = await http.get(url);
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
        '$_baseUrl/search/$book.js?query=$searchParam&start=0&limit=20&key=$_apiKey');
    print('second url: $searchUrl');
    var searchResponse = await http.get(searchUrl);
    var results = json.decode(searchResponse.body)['results'];
    print('results is $results');
    return results;
  }
}
