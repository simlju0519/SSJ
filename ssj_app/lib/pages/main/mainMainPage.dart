import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ssj/classes.dart'; // Make sure this import points to where AppText is defined
import 'package:ssj/pages/main/SearchPage.dart'; // Make sure this import points to where Page2 is defined

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // Get the screen height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()), // Ensure it's always scrollable
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width, // Ensure the minimum width equals the screen width
            minHeight: screenHeight, // Ensure the minimum height equals the screen height
          ),
          child: IntrinsicHeight( // This widget allows its child Column to be sized by the content's actual height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.values[2], // Align the column to the top
              mainAxisSize: MainAxisSize.max, // Allow the column to shrink
              children: <Widget>[

                Image.asset('assets/ssjLogoBlack.png', height: 100, width: 100),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Button background color
                    borderRadius: BorderRadius.circular(30), // Adjust for rounded corners if needed
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4), // Shadow color
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 2), // Vertical offset for the shadow
                      ),
                    ],
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const SearchRoute(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        )
                      );
                    },
                    icon: Icon(Icons.search, color: Colors.black),
                    label: Text(
                      'Search trip',
                      style: TextStyle(
                        color: Colors.black, // Text color to contrast with the background
                        fontSize: 25,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 65.0), // Button padding
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Ensures the button does not force minimum dimensions
                      // You can add more styling properties if required
                    ),
                  ),
                ),
                // Add a spacer or sized box at the end if you need more space at the bottom or want to force the column to stretch
              ],
            ),
          ),
        ),
      ),
    );
  }
}