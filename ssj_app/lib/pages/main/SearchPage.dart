import 'package:flutter/material.dart';
import 'package:ssj/classes.dart'; // Make sure this import points to where AppText is defined

class SearchRoute extends StatefulWidget {
  const SearchRoute({super.key});

  @override
  State<SearchRoute> createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  String fromName = 'Choose a station';
  String toName = 'Choose a station';


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
              AppText('Buy trip', fontSize: 40),
            ],
          ),

          SizedBox(height: 40),

          InkWell(
            child: DestPlace("From:", fromName),
            onTap: () {
              getNewPlace(context);
            },
          ),

          SizedBox(height: 20),
          
          InkWell(
            child: DestPlace("to:", toName),
            onTap: () {
              getNewPlace(context);
            },
          ),
        ],
      ),
    );
  }
}

class DestPlace extends StatelessWidget {
  final String labelDestination;
  final String StationName;
  const DestPlace(this.labelDestination, this.StationName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1,
            blurRadius: 20,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelDestination,
            textAlign: TextAlign.center, // Ensure the text is centered within the container
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            StationName,
            textAlign: TextAlign.center, // Ensure the text is centered within the container
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

void getNewPlace(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SelectStationPage(),
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
}


class SelectStationPage extends StatefulWidget {
  const SelectStationPage({super.key});

  @override
  State<SelectStationPage> createState() => _SelectStationPageState();
}

class _SelectStationPageState extends State<SelectStationPage> {
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
              IconButton.filled(
                iconSize: 40,
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                icon: const Icon(Icons.arrow_back),
              ),
              AppText('Select station', fontSize: 40),
            ],
          ),

          SizedBox(height: 40),

          InkWell(
            child: DestPlace("From:", 'Choose a station'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),

          SizedBox(height: 20),
          
          InkWell(
            child: DestPlace("to:", 'Choose a station'),
            onTap: () {
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

