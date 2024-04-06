import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ssj/classes.dart'; // Make sure this import points to where AppText is defined
import 'dart:developer' as d;
import 'package:ssj/pages/main/findTripPage.dart';


class SearchRoute extends StatefulWidget {
  const SearchRoute({super.key});

  @override
  State<SearchRoute> createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  Map fromDest = {'city': 'Choose a station', 'coordinates': [0.0, 0.0]};
  Map toDest = {'city': 'Choose a station', 'coordinates': [0.0, 0.0]};

  Map oldFromDest = {'city': 'Choose a station', 'coordinates': [0.0, 0.0]};
  Map oldToDest = {'city': 'Choose a station', 'coordinates': [0.0, 0.0]};

  bool canShowMap = false;

  List<List<double>> StationCoordinates = [];

  void changingStation(bool isFrom) async {
    final userData = await getNewDestPage(context);
    if (userData != null) {
      setState(() {
        if (isFrom) fromDest = userData; 
        else toDest = userData;
      });
      print('Selected station: ${userData}');
      
      if (fromDest['city'] != 'Choose a station' && toDest['city'] != 'Choose a station') {
        if (fromDest != oldFromDest || toDest != oldToDest) {
          oldFromDest = fromDest;
          oldToDest = toDest;
          setState(() {
            canShowMap = false;
          });
          d.log('Getting coordinates');
        }
        setState(() {
          canShowMap = true;
        });
      }
    }
  }

  getDataCoodinates() {
    // Get the coordinates of the stations
    // This function is not implemented in this example
    // It should return the coordinates of the stations
    // that are selected in the fromName and toName variables

    // Example:
    StationCoordinates = [[56.166497, 15.585361], [57.7091812, 11.9730036]];
  }

  showContinueButton() {
    // This function should return a FloatingActionButton that navigates to the FindRidePage
    // when pressed. The button should only be shown if both fromDest and toDest are set to a station

    if (fromDest['city'] != 'Choose a station' && toDest['city'] != 'Choose a station') {
      return FloatingActionButton.extended(
        onPressed: () {
          d.log('Continue button pressed');
          goToFindRoutePage(context);
        },
        icon: Icon(
              Icons.arrow_forward,
              size: 30,
            ),
        label: CommonTextApp(
              text: 'Continue',
              isBold: true,
              fontSize: 25,
        )
      );
    }
    return null;
  }

  void initState() {
    super.initState();
    // getDataCoodinates();
  }

  showMap() {
    // This function should return a map widget that shows the route between the two stations
    // The map should only be shown if both fromDest and toDest are set to a station
    
    d.log('Can show map: $canShowMap');
    if (canShowMap) {
      d.log('Updating map');
      return Container(
        width: MediaQuery.of(context).size.width * 0.74,
        height: MediaQuery.of(context).size.width * 0.74,
        child: ShowCaseStartEndMap(
          start: fromDest['coordinates'], 
          end: toDest['coordinates']
        ),
      );
    }
    return Container();
  }

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

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Column(
                children: [
                  InkWell(
                    child: DestPlace("From:", fromDest['city']),
                    onTap: () {
                      changingStation(true);
                    },
                  ),

                  SizedBox(height: 20),
                  
                  InkWell(
                    child: DestPlace("to:", toDest['city']),
                    onTap: () {
                      changingStation(false);
                    },
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() {
                  var temp = fromDest;
                  fromDest = toDest;
                  toDest = temp;

                  canShowMap = false;
                  if (fromDest['city'] != 'Choose a station' && toDest['city'] != 'Choose a station'){
                    canShowMap = true;
                  }
                }),
                child: Icon(
                  Icons.swap_vert_sharp,
                  size: 40,
                ),
              )
            ],
          ),


          SizedBox(height: 20), // Add some space between the destination and the map
          
          showMap()
        ],
      ),
      floatingActionButton: showContinueButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
      width: MediaQuery.of(context).size.width * 0.825,
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
          CommonTextApp(
            text: labelDestination,
            fontSize: 20,
            isBold: true,
          ), // Use the CommonTextApp widget to create the label (From: or To:
          CommonTextApp(
            text: StationName,
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}

Future<dynamic> getNewDestPage(BuildContext context) {
  return Navigator.of(context).push(
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

Future<dynamic> goToFindRoutePage(BuildContext context) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const FindRidePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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

  List<Map> showingStations = [];
  List<Map> allStations = [];
  

  void getData() {
    List<Map> gatheredTestData = [
      {
        'stationName' : 'Göteborgs Central Station', 
        'CityName': 'Gothenburg',
        'Coordinates': [57.7091812, 11.9730036],
      },
      {
        'stationName' : 'Stockholms Central Station',
        'CityName': 'Stockholm',
        'Coordinates': [59.3306501, 18.0595811],
      },
      {
        'stationName' : 'Malmö Central Station',
        'CityName': 'Malmö',
        'Coordinates': [55.6092245, 13.0004857],
      },
      {
        'stationName' : 'Lund Central Station',
        'CityName': 'Lund',
        'Coordinates': [55.7046602, 13.1910078],
      },
      {
        'stationName' : 'Helsingborg Central Station',
        'CityName': 'Helsingborg',
        'Coordinates': [56.046467, 12.694496],
      },
      {
        'stationName': 'Uppsala Central Station',
        'CityName': 'Uppsala',
        'Coordinates': [59.8585626, 17.6389275],
      },
      {
        'stationName': 'Västerås Central Station',
        'CityName': 'Västerås',
        'Coordinates': [59.609521, 16.545587],
      },
      {
        'stationName': 'Örebro Central Station',
        'CityName': 'Örebro',
        'Coordinates': [59.274337, 15.206608],
      },
      {
        'stationName': 'Linköping Central Station',
        'CityName': 'Linköping',
        'Coordinates': [58.410807, 15.621372],
      },
      {
        'stationName': 'Norrköping Central Station',
        'CityName': 'Norrköping',
        'Coordinates': [58.594241, 16.187622],
      },
      {
        'stationName': 'Jönköping Central Station',
        'CityName': 'Jönköping',
        'Coordinates': [57.782613, 14.161911],
      },
      {
        'stationName': 'Växjö Central Station',
        'CityName': 'Växjö',
        'Coordinates': [56.878718, 14.809431],
      },
      {
        'stationName': 'Kalmar Central Station',
        'CityName': 'Kalmar',
        'Coordinates': [56.663588, 16.356779],
      },
      {
        'stationName': 'Karlskrona Central Station',
        'CityName': 'Karlskrona',
        'Coordinates': [56.161678, 15.586604],
      },
      {
        'stationName': 'Halmstad Central Station',
        'CityName': 'Halmstad',
        'Coordinates': [56.6745, 12.8562],
      },
      {
        'stationName': 'Gävle Central Station',
        'CityName': 'Gävle',
        'Coordinates': [60.6745, 17.1412],
      },
      {
        'stationName': 'Borås Central Station',
        'CityName': 'Borås',
        'Coordinates': [57.7210, 12.9401],
      },
    ];

    for (var i = 0; i < gatheredTestData.length; i++) {
      allStations.add({
        'name': gatheredTestData[i]['stationName'],
        'city': gatheredTestData[i]['CityName'],
        'coordinates': gatheredTestData[i]['Coordinates'],
      });
      
      // Copy all stations to showingStations
      showingStations = List.from(allStations);
    }
  }

  void updateStationsFromSearch(String search) {

    List<Map> newStations = [];
    if (search.isEmpty) {
      newStations = List.from(allStations);
    }
    else{
      for (var i = 0; i < allStations.length; i++) {
        if (allStations[i]['name'].toString().toLowerCase().contains(search) || allStations[i]['city'].toString().toLowerCase().contains(search)) {
          newStations.add(allStations[i]);
        }
      }
    }
    setState(() {
      showingStations = newStations;
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 120),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: AppText('Select station', fontSize: 40, canPop: true),
          ),
          SizedBox(height: 10),

          // Search bar for stations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: (value) {
                updateStationsFromSearch(value);
              },
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
              decoration: InputDecoration(
                
                hintText: 'Search for a station',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // List of stations to choose from
          Expanded(
            // The Expanded widget allows the ListView to take up all remaining space
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: showingStations.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Card(
                    child: ListTile(
                      title: CommonTextApp(
                        text: showingStations[index]['name'],
                        fontSize: 20,
                        isBold: true,
                      ),
                      subtitle: CommonTextApp(
                        text: showingStations[index]['city'],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(showingStations[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

