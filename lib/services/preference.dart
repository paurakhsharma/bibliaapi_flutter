import 'package:onesheep_test/models/bible.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String defaultBible = 'KJV';
final String defaultTitle = 'King James Version';
final String defaultStartingVerse = 'John 1: 1';

class Preference {
  SharedPreferences prefs;

  initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  Bible getSelectedBible() {
    /**
    * If the selectedBible is set return it
    * else set it to default value
    */
    var selectedBible = prefs.getStringList('selectedBible');
    if (selectedBible == null) {
      selectedBible = [defaultBible, defaultTitle];
      updateSelectedBible(selectedBible[0], selectedBible[1]);
    }
    return Bible(bible: selectedBible[0], title: selectedBible[1]);
  }

  updateSelectedBible(bible, title) {
    prefs.setStringList('selectedBible', [bible, title]);
  }

  getTodayVerse() {
    /**
     * If this is the new day returns new verse
     * else, return current verse
     */
    var newVerse;
    DateTime now = DateTime.now();
    var today = prefs.getString('today');
    if (today == null) {
      today = now.toString();
      prefs.setString('today', today);
    }
    DateTime savedDay = DateTime.parse(today);
    var lastVerse = prefs.getString('verse');
    if (lastVerse == null) {
      lastVerse = defaultStartingVerse;
      prefs.setString('verse', lastVerse);
    }
    // Testing tip change .inDays to .inMinuts so that
    // you get new verse every new minute
    if (now.difference(savedDay).inDays > 0) {
      prefs.setString('today', now.toString());
      newVerse = getNewVerse(lastVerse);
    } else
      newVerse = lastVerse;
    return newVerse;
  }

  getNewVerse(lastVerse) {
    /**
     * Increase verse number
     */
    var bibleVerse = verseStringToList(lastVerse);
    var newVerse;
    if (bibleVerse[0] == null) {
      // if the curren't verse's book doesn't contain part
      // e.g John 1:2, Matthew 12: 11
      newVerse = '${bibleVerse[1]} ${bibleVerse[2]}:${int.parse(bibleVerse[3]) + 1}';
      prefs.setString('verse', newVerse);
    } else
      newVerse =
          '${bibleVerse[0]}${bibleVerse[1]} ${bibleVerse[2]}:${int.parse(bibleVerse[3]) + 1}';
    return newVerse;
  }

  updateSharedPreferenceVerse(newVerse) {
    prefs.setString('verse', newVerse);
  }

  verseStringToList(stringVerse) {
    // Regex to match the Part of book, name of book, chapter and verse
    RegExp regExp = new RegExp(r'(\d )*([a-zA-Z]+).(\d+):(\d+)');
    return regExp.firstMatch(stringVerse).groups([1, 2, 3, 4]);
  }
}
