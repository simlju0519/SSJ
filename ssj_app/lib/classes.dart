import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class AppText extends StatelessWidget {
  final String text;
  final double fontSize; // Make fontSize final
  final double elevation;
  final double blurRadius;
  final bool canPop;

  // Set a default value for fontSize directly in the constructor
  const AppText(this.text, {this.fontSize = 30, this.elevation = 1, this.blurRadius = 100, this.canPop = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1,
            blurRadius: blurRadius,
            offset: Offset(0, elevation), // Changes position of shadow
          ),
        ],
      ),
      child: Expanded( // Makes the text expand to fill the row, helping center the text
        child: Row(
          mainAxisSize: MainAxisSize.min, // Allow the row to shrink
          children: [
            if (canPop) // Use `if` inside the collection to conditionally include the back button
              IconButton(
                iconSize: fontSize * 0.8, // Adjust the back button size to match the text
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Text align is now redundant with Expanded
            ),
          ],
        ),
      ),
    );
  }
}


class InfoContainer {
  InfoContainer._();
  static final instance = InfoContainer._();

  Color primaryColor = Colors.white;
  Color secondaryColor = Colors.white;
  Color fontColor = Colors.white;
  Color accentColor = Colors.white;

  void setWhiteTheme() {
    primaryColor = Colors.white;
    secondaryColor = Colors.black;
    fontColor = Colors.black;
  }

  void setDarkTheme() {
    primaryColor = Colors.black;
    secondaryColor = Colors.white;
    fontColor = Colors.white;
  }
}