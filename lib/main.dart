import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'widget/button_widget.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widget/navigation_drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CSUN Navigation App',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const MyHomePage(title: 'CSUN Navigation App'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  final LatLng _center = const LatLng(34.24138, -118.52946);
  static const LatLng userLocation = LatLng(36.24138, -118.52946);
  static const LatLng destination = LatLng(34.24138, -118.52946);

  /*void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future permissionHandler() async{
    var status = await Permission.location.status;
    if(status.isGranted){
      // location permission is granted
    }
    else if (status.isDenied){
      // location permission is not granted
      status = await Permission.location.request();
    }

    if(await Permission.location.isPermanentlyDenied){
      openAppSettings();
    }
  }

  LocationData? currentLocation;
  void getCurrentLocation() async{
    Location location = Location();

    location.getLocation().then(
      (location){
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc){
        currentLocation = newLoc;

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 15.0,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );

      setState(() {});
      },
    );
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBnRMozHUDAfh2XsbAm_hjKEIIKeUZi-v0",
      PointLatLng(userLocation.latitude, userLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if(result.points.isNotEmpty){
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
          ),
      );
      setState(() {});
    }
  }

  void initState(){
    getPolyPoints();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            if (_scaffoldKey.currentState!.isDrawerOpen) {
              _scaffoldKey.currentState!.closeDrawer();
            } else {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FlutterLogo(size: 80),
                    Text('Oscar Ibarra'),
                    Text('oscar.ibarra.194@my.csun.edu'),
                  ],
                )),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, 'main.dart');
              },
            ),
            ListTile(
              title: Text('Leaderboard'),
              onTap: () {
                Navigator.pushNamed(context, '/Leaderboard');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/Settings');
              },
            ),
          ],
        ),
      ),
      endDrawer: NavigationDrawerWidget(),
      body: GoogleMap(
        //onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: {
          const Marker(
            markerId: MarkerId("user"),
            position: userLocation,
          ),
          const Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      ),
      /*polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: const Color(0xFF7B61FF),
          width: 6,
          ),
      },*/
    ));
  }
}