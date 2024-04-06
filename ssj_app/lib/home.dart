import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:ssj/pages/mainPage.dart';
import 'package:ssj/pages/TicketPage.dart';
import 'package:ssj/classes.dart';
import 'package:flutter/cupertino.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabs;
  late List<String> _tabTitles;
  int _currentIndex = 0;
  int _lastPressed = 0;

  List keys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = [
      MainPageMang(navKey: keys[0],),
      TicketPageMang(navKey: keys[1],),
    ];
    _tabTitles = ['Home', 'Tickets'];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabIndex);
  }

  void _popAllRoutes(int value) {
    bool popping = true;
    while (popping) {
      popping = keys[value].currentState!.canPop();
      if (popping) {
        keys[value].currentState!.pop();
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            title: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  _popAllRoutes(_currentIndex);
                },
                child: AppText(
                  _tabTitles[_currentIndex], 
                  fontSize: 30,
                  blurRadius: 2,
                ),
              ),
            ), // Ensure AppText accepts fontSize
            actions: <Widget>[
              Align(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 20,
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.person_outline),
                      onPressed: () {
                        dev.log('Profile button pressed');
                      },
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow if any
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MainPageMang(navKey: keys[0],),
            TicketPageMang(navKey: keys[1],),

          ],
        ),
        bottomNavigationBar: Material(
          color: Theme.of(context).primaryColor, // This uses your theme's primary color.
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            labelStyle: TextStyle(fontSize: 18),

            indicatorSize: TabBarIndicatorSize.tab, // Makes the indicator width equal to the whole tab
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.white, // Color of the indicator
                width: 3.0, // Thickness of the indicator
              ),
              insets: EdgeInsets.symmetric(horizontal:25.0), // Insets for the indicator
            ),
            onTap: (value) {
              // Prevents the user from popping the current tab's route
              setState(() {
                if (_lastPressed == value) {
                  // Pop all routes in the current tab
                  _popAllRoutes(value);
                }
                _lastPressed = value;
              });
            },

            tabs: const [
              Tab(icon: Icon(Icons.train_outlined, size: 25), text: "Home"),
              Tab(icon: Icon(CupertinoIcons.tickets), text: "Tickets"),
            ],
          ),
        ),
      ),
    );
  }
}
