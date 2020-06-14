import 'package:flutter/material.dart';
import 'package:onesheep_test/components/dropdown.dart';
import 'package:onesheep_test/provider/bible_notifier.dart';
import 'package:onesheep_test/screens/search_screen.dart';
import 'package:onesheep_test/utilities/constants.dart';
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
    Widget buildSearchButton() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: TextField(
          onSubmitted: (value) {
            bibleProvider.search(value);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchScreen(
                searchParam: value,
              ),
            ));
          },
          style: kTextStyleAction(Theme.of(context).accentColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF9F9F9),
            hintText: 'Lost Sheep',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            suffixIcon: Icon(
              Icons.search,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              buildSearchButton(),
              SizedBox(
                height: 10,
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
                            onChanged: (value) => bibleProvider.selectBible(value)),
                        Divider(
                          thickness: 1,
                          height: 5,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(height: 70),
                        Text(
                          'Verse of the Day',
                          style: kTextStyleTitle(context, 28.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          bibleProvider.verseText,
                          style: kTextStyleVerse(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          child: Text(
                            bibleProvider.verse,
                            style: kTextStyleVerse(),
                          ),
                          alignment: Alignment.bottomRight,
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          )),
    );
  }
}
