import 'package:flutter/material.dart';
import 'package:onesheep_test/models/bible.dart';
import 'package:onesheep_test/services/services.dart';

class BibleNotifier extends ChangeNotifier {
  List<Bible> _bibles;
  Bible _selectedBible;
  String _verseText;
  String _verse = "John 3:16";
  String _searchParam;
  bool _loading = true;
  List _searchResult = [];
  var httpService = BibleService();

  get bibles => _bibles;
  get selectedBible => _selectedBible;
  get verseText => _verseText;
  get verse => _verse;
  get isLoading => _loading;
  get searchResult => _searchResult;

  startLoading() {
    _loading = true;
    notifyListeners();
  }

  stopLoading() {
    _loading = false;
    notifyListeners();
  }

  selectBible(selectedBible) async {
    startLoading();
    _selectedBible = _bibles.firstWhere((bible) => bible.title == selectedBible);
    await getBibleVerse();
    stopLoading();
  }

  selectBibleSearch(selectedBible) async {
    startLoading();
    _selectedBible = _bibles.firstWhere((bible) => bible.title == selectedBible);
    await search(_searchParam);
    stopLoading();
  }

  initialize() async {
    await httpService.loadConfig();
    await getBibles();
    await getVerseOfTheDay();
    stopLoading();
  }

  getBibleVerse() async {
    _verseText = await httpService.getVerse(_verse, _selectedBible.bible);
    notifyListeners();
  }

  getBibles() async {
    _bibles = await httpService.getAllBibles();
    _selectedBible = _bibles[0];
    notifyListeners();
  }

  search(searchParam) async {
    print('search param is: $searchParam');
    startLoading();
    _searchParam = searchParam;
    _searchResult = await httpService.search(searchParam, _selectedBible.bible);
    print('search result: $_searchResult');
    stopLoading();
  }

  getVerseOfTheDay() async {
    List verseList = await httpService.getVerseOfTheDay(_selectedBible.bible);
    _verse = verseList[0];
    _verseText = verseList[1];
    notifyListeners();
  }
}
