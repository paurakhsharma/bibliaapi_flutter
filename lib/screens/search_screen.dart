import 'package:flutter/material.dart';
import 'package:onesheep_test/components/dropdown.dart';
import 'package:onesheep_test/components/searchbar.dart';
import 'package:onesheep_test/provider/bible_notifier.dart';
import 'package:onesheep_test/utilities/constants.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bibleProvider = Provider.of<BibleNotifier>(context);

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
              SearchBar((value) => bibleProvider.search(value)),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                height: 5,
                color: Theme.of(context).accentColor,
              ),
              !bibleProvider.isLoading
                  ? Flexible(
                      child: Column(
                        children: <Widget>[
                          DropDown(
                            context,
                            bibles: bibleProvider.bibles,
                            dropDownValue: bibleProvider.selectedBible,
                            onChanged: (value) => bibleProvider.selectBibleSearch(value),
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(height: 20),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: ListView.separated(
                              padding: EdgeInsets.all(5),
                              separatorBuilder: (context, index) => Divider(
                                thickness: 1,
                                height: 5,
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext ctx, int index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        bibleProvider.searchResult[index]['title'],
                                        style: kTextStyleTitle(context, 22.0),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        bibleProvider.searchResult[index]['preview'],
                                        style: kTextStyleVerse(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: bibleProvider.searchResult.length,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            height: 5,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          )),
    );
  }
}
