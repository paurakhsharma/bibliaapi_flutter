import 'package:flutter/material.dart';
import 'package:onesheep_test/utilities/constants.dart';

Widget DropDown(context, {@required books, @required onChanged, @required dropDownValue}) {
  return DropdownButton(
    underline: Text(''),
    hint: dropDownValue == null
        ? Text(
            books[0],
            style: kTextStyleAction(Theme.of(context).accentColor),
          )
        : Text(
            dropDownValue,
            style: kTextStyleAction(Theme.of(context).accentColor),
          ),
    isExpanded: true,
    iconSize: 50.0,
    iconEnabledColor: Theme.of(context).accentColor,
    style: TextStyle(color: Colors.blue),
    items: books.map<DropdownMenuItem>(
      (val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              val,
              style: kTextStyleAction(Theme.of(context).accentColor),
            ),
          ),
        );
      },
    ).toList(),
    onChanged: onChanged,
  );
}
