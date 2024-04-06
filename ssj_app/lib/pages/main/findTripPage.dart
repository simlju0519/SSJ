import 'package:flutter/material.dart';
import 'package:ssj/classes.dart';

class FindRidePage extends StatefulWidget {
  const FindRidePage({super.key});

  @override
  State<FindRidePage> createState() => _FindRidePageState();
}

class _FindRidePageState extends State<FindRidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 120),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 18),
              AppText(
                'Choose trip', 
                fontSize: 40,
                canPop: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}