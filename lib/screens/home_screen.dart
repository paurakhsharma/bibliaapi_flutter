import 'package:flutter/material.dart';
import 'package:onesheep_test/components/dropdown.dart';
import 'package:onesheep_test/components/error.dart';
import 'package:onesheep_test/components/loading.dart';
import 'package:onesheep_test/components/searchbar.dart';
import 'package:onesheep_test/provider/bible_notifier.dart';
import 'package:onesheep_test/screens/search_screen.dart';
import 'package:onesheep_test/utilities/constants.dart';
import 'package:onesheep_test/utilities/responsive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BibleNotifier>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    var bibleProvider = Provider.of<BibleNotifier>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
          padding: EdgeInsets.all(isSmallScreen(context) ? 8.0 : 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SearchBar((value) {
                bibleProvider.search(value);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              }),
              SizedBox(
                height: isSmallScreen(context) ? 10 : 30,
              ),
              Divider(
                thickness: 1,
                height: 5,
                color: Theme.of(context).accentColor,
              ),
              !bibleProvider.isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropDown(context,
                            bibles: bibleProvider.bibles,
                            dropDownValue: bibleProvider.selectedBible,
                            onChanged: (value) => bibleProvider.selectBible(value),
                            icon: bibleProvider.bibles.length > 1
                                ? Icon(Icons.arrow_drop_down)
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  )),
                        Divider(
                          thickness: 1,
                          height: 5,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(height: 70),
                        Text(
                          'Verse of the Day',
                          style: kTextStyleTitle(context, isSmallScreen(context) ? 28.0: 44.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          bibleProvider.verseText,
                          style: kTextStyleVerse(context),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          child: Text(
                            bibleProvider.verse,
                            style: kTextStyleVerse(context),
                          ),
                          alignment: Alignment.bottomRight,
                        )
                      ],
                    )
                  : LoadingIndicator(),
              SnackBarLauncher(
                error: bibleProvider.error
                    ? 'Problem connecting to the internet \n'
                        'Make sure you have active internet connection'
                    : null,
              )
            ],
          )),
    );
  }
}
