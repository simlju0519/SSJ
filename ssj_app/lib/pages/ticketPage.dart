import 'package:flutter/material.dart';
import 'package:ssj/pages/ticket/ticketMainPage.dart';

class TicketPageMang extends StatefulWidget {
  GlobalKey <NavigatorState> navKey;
  TicketPageMang({required this.navKey, super.key});

  @override
  State<TicketPageMang> createState() => _TicketPageMangState();
}

class _TicketPageMangState extends State<TicketPageMang> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => TicketPage(),
      },
      navigatorKey: widget.navKey,
    );
  }
}