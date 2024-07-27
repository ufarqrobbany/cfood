import 'package:flutter/material.dart';

void navigateTo(BuildContext? context, Widget page) {
  Navigator.push(
    context!,
    MaterialPageRoute(builder: (context) => page,)
    );
}

void navigateBack(BuildContext? context) {
  Navigator.of(context!).pop();
}

void navigateToRep(BuildContext? context, Widget page) {
  Navigator.pushReplacement(context!, MaterialPageRoute(builder: (context) => page,));
}