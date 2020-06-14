import 'package:flutter/material.dart';
import 'package:onesheep_test/utilities/constants.dart';

Widget DropDown(context, {@required bibles, @required onChanged, @required dropDownValue, @required Widget icon}) {
  return DropdownButton(
    underline: Text(''),
    hint: dropDownValue == null
        ? Text(
            bibles[0].title,
            style: kTextStyleAction(Theme.of(context).accentColor),
          )
        : Text(
            dropDownValue.title,
            style: kTextStyleAction(Theme.of(context).accentColor),
          ),
    isExpanded: true,
    iconSize: 50.0,
    iconEnabledColor: Theme.of(context).accentColor,
    style: TextStyle(color: Colors.blue),
    icon: icon,
    items: bibles.map<DropdownMenuItem>(
      (bible) {
        return DropdownMenuItem<String>(
          value: bible.title,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              bible.title,
              style: kTextStyleAction(Theme.of(context).accentColor),
            ),
          ),
        );
      },
    ).toList(),
    onChanged: onChanged,
  );
}
