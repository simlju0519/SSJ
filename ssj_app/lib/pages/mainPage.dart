import 'package:flutter/material.dart';
import 'package:ssj/classes.dart';
import 'package:ssj/pages/main/mainMainPage.dart';
import 'package:ssj/pages/main/SearchPage.dart';

class MainPageMang extends StatefulWidget {
  GlobalKey <NavigatorState> navKey;
  MainPageMang({required this.navKey, super.key});
  // const MainPageMang({Key? key}) : super(key: key);

  @override
  State<MainPageMang> createState() => _MainPageMangState();
}

class _MainPageMangState extends State<MainPageMang> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => MainPage(),
        'search': (context) => SearchRoute(),
      },
      navigatorKey: widget.navKey,
    );
  }
}
