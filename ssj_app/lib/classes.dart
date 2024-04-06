import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'dart:math' as math;


import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    );
  }
}

class CommonTextApp extends StatelessWidget {
  String text;
  double fontSize;
  bool isBold;
  Color? color;
  CommonTextApp({
    this.fontSize = 20, 
    this.isBold = false, 
    this.color = null, 
    required this.text, 
    super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
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

class ShowCaseStartEndMap extends StatefulWidget {
  final List<double> start;
  final List<double> end;

  const ShowCaseStartEndMap({
    required this.start,
    required this.end,
    super.key,
  });

  @override
  State<ShowCaseStartEndMap> createState() => _ShowCaseStartEndMapState();
}

class _ShowCaseStartEndMapState extends State<ShowCaseStartEndMap> {
  GoogleMapController? _googleMapController;
  late Marker _startMarker;
  late Marker _endMarker;
  late Polyline _polyline;

  @override
  void initState() {
    super.initState();
    setCoordinates();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  void setCoordinates() {
    BitmapDescriptor startIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    BitmapDescriptor endIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

    setState(() {
      _startMarker = Marker(
        markerId: MarkerId('start'),
        icon: startIcon,
        position: LatLng(widget.start[0], widget.start[1]),
        infoWindow: InfoWindow(title: 'Start', snippet: 'Start Position'),
      );
      _endMarker = Marker(
        markerId: MarkerId('end'),
        icon: endIcon,
        position: LatLng(widget.end[0], widget.end[1]),
        infoWindow: InfoWindow(title: 'End', snippet: 'End Position'),
      );
      _polyline = Polyline(
        polylineId: PolylineId('path'),
        color: Colors.purple,
        width: 8,
        points: [
          LatLng(widget.start[0], widget.start[1]),
          LatLng(widget.end[0], widget.end[1]),
        ],
      );
    });
  }

  void onMapCreated(GoogleMapController controller) {
    dev.log('HELLOOOOO');
    _googleMapController = controller;
    adjustCamera();
  }

  void adjustCamera() {
    if (_googleMapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        math.min(widget.start[0], widget.end[0]),
        math.min(widget.start[1], widget.end[1]),
      ),
      northeast: LatLng(
        math.max(widget.start[0], widget.end[0]),
        math.max(widget.start[1], widget.end[1]),
      ),
    );

    _googleMapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    dev.log('Building map');
    dev.log(widget.start.toString());
    dev.log(widget.end.toString());
    adjustCamera();
    setCoordinates();
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.start[0], widget.start[1]),
            zoom: 8,
          ),
          onMapCreated: onMapCreated,
          liteModeEnabled: false,
          mapToolbarEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          markers: {_startMarker, _endMarker},
          polylines: {_polyline},
        ),
      ),
    );
  }
}
