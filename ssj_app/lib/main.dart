import 'package:flutter/material.dart';
import 'package:ssj/home.dart';
import 'package:ssj/loginPage.dart';
import 'package:flutter_config/flutter_config.dart';

// void main() => runApp(Main());


Future<void> main() async {

  final mainKey = GlobalKey();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  ThemeData theme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
  );

  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  FlutterConfig.get('GOOGLE_MAPS_API_KEY');

  var mainApp = MaterialApp(
    key: mainKey,
    routes: {
      '/home': (context) => HomeTab(),
      '/login': (context) => LoginPage(),
    },
    initialRoute: '/home',
    home: HomeTab(),
    navigatorObservers: [routeObserver],
  );

  runApp(mainApp);
}