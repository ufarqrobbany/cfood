import 'package:flutter/material.dart';


Future<T?> navigateTo<T>(BuildContext? context, Widget page) {
  return Navigator.push(
    context!,
    MaterialPageRoute(builder: (context) => page),
  );
}

void navigateBack(BuildContext? context, {dynamic result}){
  Navigator.of(context!).pop(result);
}

Future<T?> navigateToRep<T>(BuildContext? context, Widget page) {
  return Navigator.pushReplacement(
    context!,
    MaterialPageRoute(builder: (context) => page),
  );
}

void printCurrentRoutes(BuildContext context) {
  Navigator.popUntil(context, (route) {
    debugPrint(route.settings.name);
    return true;
  });
}