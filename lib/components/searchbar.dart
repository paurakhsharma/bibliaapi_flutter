import 'package:flutter/material.dart';
import 'package:onesheep_test/provider/bible_notifier.dart';
import 'package:onesheep_test/utilities/constants.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final Function onSubmitted;

  SearchBar(this.onSubmitted);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    var bibleProvider = Provider.of<BibleNotifier>(context, listen: false);
    searchController.text = bibleProvider.searchParam;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: searchController,
          validator: (value) {
            if (value.isEmpty || value == null) {
              return 'Search value must not be empty';
            }
            return null;
          },
          onFieldSubmitted: (value){
            if (_formKey.currentState.validate()) {
              widget.onSubmitted(value);
            }
          },
          style: kTextStyleAction(Theme.of(context).accentColor),
          decoration: InputDecoration(
            errorStyle: TextStyle(color: Theme.of(context).accentColor),
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
      ),
    );
  }
}
