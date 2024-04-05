import 'package:flutter/material.dart';
import 'package:ssj/home.dart';


// void main() => runApp(Main());


Future<void> main() async {

  final mainKey = GlobalKey();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  ThemeData theme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
  );

  var mainApp = MaterialApp(
    key: mainKey,
    routes: {
      '/home': (context) => HomeTab(),
    },
    initialRoute: '/home',
    home: HomeTab(),
    navigatorObservers: [routeObserver],
  );

  runApp(mainApp);
}