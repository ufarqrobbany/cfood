import 'package:flutter/material.dart';


// Future<T?> navigateTo<T>(BuildContext? context, Widget page) {
//   return Navigator.push(
//     context!,
//     MaterialPageRoute(builder: (context) => page),
//   );
// }

void navigateBack(BuildContext? context, {dynamic result}){
  Navigator.of(context!).pop(result);
}

// Future<T?> navigateToRep<T>(BuildContext? context, Widget page) {
//   return Navigator.pushReplacement(
//     context!,
//     MaterialPageRoute(builder: (context) => page),
//   );
// }

void printCurrentRoutes(BuildContext context) {
  Navigator.popUntil(context, (route) {
    debugPrint(route.settings.name);
    return true;
  });
}

Future<T?> navigateTo<T>(BuildContext context, Widget page, {String? routeName}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: routeName),
    ),
  );
}



Future<T?> navigateToRep<T>(BuildContext context, Widget page, {String? routeName}) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: routeName),
    ),
  );
}

class RouteLogger extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    print('Current Route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    print('Current Route after pop: ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Current Route after replace: ${newRoute?.settings.name}');
  }
}