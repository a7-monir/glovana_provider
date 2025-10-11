import 'package:flutter/material.dart';

Future pushScreen(BuildContext context, Widget screen) async {
  await Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(builder: (context) => screen),
  );
}

Future pushReplacementScreen(BuildContext context, Widget screen) async {
  await Navigator.of(context, rootNavigator: true).pushReplacement(
    MaterialPageRoute(builder: (context) => screen),
  );
}

Future pushAndRemoveAll(BuildContext context, Widget screen) async {
  await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => screen),
        (route) => false,
  );
}

void popScreen(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
