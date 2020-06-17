import 'package:flutter/material.dart';

class SnackBarLauncher extends StatelessWidget {
  final String error;

  const SnackBarLauncher(
      {Key key, @required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _displaySnackBar(context, error: error));
    }
    // Placeholder container widget
    return Container();
  }

  void _displaySnackBar(BuildContext context, {@required String error}) {
    final snackBar = SnackBar(content: Text(error));
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }
}