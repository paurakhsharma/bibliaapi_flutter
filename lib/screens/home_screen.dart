import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesheep_test/components/dropdown.dart';
import 'package:onesheep_test/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropDownValue;
  List books = [
    "ASV",
    "ARVANDYKE",
    "KJV",
    "LSG",
    "BYZ",
    "DARBY",
    "Elzevir",
    "ITDIODATI1649",
    "EMPHBBL",
    "KJV1900",
    "KJVAPOC",
    "LEB",
    "SCRMORPH",
    "FI-RAAMATTU",
    "RVR60",
    "RVA",
    "bb-sbb-rusbt",
    "eo-zamenbib",
    "TR1881",
    "TR1894MR",
    "SVV",
    "STEPHENS",
    "TANAKH",
    "wbtc-ptbrnt",
    "WH1881MR",
    "YLT"
  ];

  @override
  Widget build(BuildContext context) {
    Widget buildSearchButton() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: TextField(
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
            DropDown(context, books: books, dropDownValue: _dropDownValue, onChanged: (value) {
              setState(() {
                _dropDownValue = value;
              });
            }),
            Divider(
              thickness: 1,
              height: 5,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(height: 70),
            Text(
              'Verse of the Day',
              style: kTextStyleTitle(context),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'My people have become lost sheep, '
              'their shepherds have caused them to go astray. '
              'They led them away to the mountains. '
              'From mountain to hill they have gone, '
              'they have forgotten their resting place.',
              style: kTextStyleVerse(),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              child: Text(
                'Jeremiah 50:6',
                style: kTextStyleVerse(),
              ),
              alignment: Alignment.bottomRight,
            )
          ],
        ),
      ),
    );
  }
}
