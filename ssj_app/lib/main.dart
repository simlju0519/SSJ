import 'package:flutter/material.dart';
import 'package:ssj/home.dart';
import 'package:ssj/loginPage.dart';


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
      '/login': (context) => LoginPage(),
    },
    initialRoute: '/login',
    home: HomeTab(),
    navigatorObservers: [routeObserver],
  );

  runApp(mainApp);
}