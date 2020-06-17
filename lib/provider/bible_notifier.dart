import 'package:flutter/material.dart';
import 'package:onesheep_test/models/bible.dart';
import 'package:onesheep_test/services/services.dart';

class BibleNotifier extends ChangeNotifier {
  List<Bible> _bibles;
  Bible _selectedBible;
  String _verseText;
  String _verse;
  String _searchParam;
  bool _loading = true;
  List _searchResult = [];
  var bibleService = BibleService();

  get bibles => _bibles;
  get selectedBible => _selectedBible;
  get verseText => _verseText;
  get verse => _verse;
  get isLoading => _loading;
  get searchResult => _searchResult;
  get searchParam => _searchParam;

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
    setNewBible(selectedBible);
    await getBibleVerse();
    stopLoading();
  }

  selectBibleSearch(selectedBible) async {
    startLoading();
    setNewBible(selectedBible);
    await search(_searchParam);
    stopLoading();
  }

  setNewBible(selectedBible) {
    _selectedBible = _bibles.firstWhere((bible) => bible.title == selectedBible);
    bibleService.updateSelectedBible(_selectedBible.bible, _selectedBible.title);
  }

  initialize() async {
    await bibleService.initialize();
    await loadBible();
    await getVerseOfTheDay();
    stopLoading();
    // Getting all the bibles takes way too long,
    // So, let it run in the background.
    getBibles();
  }

  loadBible() {
    _selectedBible = bibleService.loadSelectedBible();
    _bibles = [_selectedBible];
    notifyListeners();
  }

  getBibleVerse() async {
    _verseText = await bibleService.getVerse(_verse, _selectedBible.bible);
    notifyListeners();
  }

  getBibles() async {
    _bibles = await bibleService.getAllBibles();
    notifyListeners();
  }

  search(searchParam) async {
    startLoading();
    // save the search param in the provider
    //so that we can access if from the search page as well
    _searchParam = searchParam;
    _searchResult = await bibleService.search(searchParam, _selectedBible.bible);
    stopLoading();
  }

  getVerseOfTheDay() async {
    List verseList = await bibleService.getVerseOfTheDay(_selectedBible.bible);
    _verse = verseList[0];
    _verseText = verseList[1];
    notifyListeners();
  }
}
