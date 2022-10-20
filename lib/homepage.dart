import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'widget/navigation_drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Completer<GoogleMapController> _controller = Completer();
  //final LatLng _center = const LatLng(34.24138, -118.52946);
  //static const LatLng userLocation = LatLng(34.24138, -118.52946);
  //static const LatLng destination = LatLng(34.24138, -118.52946);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _currentAddress;
  Position? _currentPosition;

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
                  /*
              ListTile(
                title: Text('Home'),
                onTap: (){
                  Navigator.pushNamed(context, 'homepage.dart'),;
                },
              ),
              */
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
            body: const Center(
              child: BodyWidget(),
            )
            /*
        GoogleMap(
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
        */
            ));
  }

  /*
  Future<bool> _handleLocationPermission() async{
    bool serviceEnabled;
    LocationPermission permission; 
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if(!serviceEnabled){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
       content: Text('Location services are disabled. Please enable the services')
     ));
     return false;
   }
 
   permission = await Geolocator.checkPermission();
   if(permission == LocationPermission.denied){
     permission = await Geolocator.requestPermission();
     if(permission == LocationPermission.denied){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Location permissions are denied.'))
       );
       return false;
     }
   }
   if(permission == LocationPermission.deniedForever){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
       content: Text('Location permissions are permanently denied, we cannot request permissions.')
     ));
     return false;
   }
   return true;
  }

  Future<void> _getCurrentPosition() async{
    final hasPermission = await _handleLocationPermission();
 
   if(!hasPermission){
     return;
   }
   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position){
     setState(() => _currentPosition = position);
     _getAddressFromLatLng(_currentPosition!);
   }).catchError((e){
     debugPrint(e);
   });
  }

  Future<void> _getAddressFromLatLng(Position position) async{
    await placemarkFromCoordinates(
     _currentPosition!.latitude, _currentPosition!.longitude
   ).then((List <Placemark> placemarks){
     Placemark place = placemarks[0];
     setState((){
       _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
     });
   }).catchError((e){
     debugPrint(e);
   });
  }
  */
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final GlobalKey key = GlobalKey();
  bool _offStage = false;

  Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(34.24138, -118.52946);
  static const LatLng userLocation = LatLng(34.24138, -118.52946);
  static const LatLng destination = LatLng(34.24138, -118.52946);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _currentAddress;
  Position? _currentPosition;

  Size _getFlutterLogoSize() {
    final RenderBox renderLogo =
        key.currentContext!.findRenderObject()! as RenderBox;
    return renderLogo.size;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
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
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
        ),
        Offstage(
          offstage: _offStage,
          child: ElevatedButton(
              child: FlutterLogo(
                key: key,
                size: 150.0,
              ),
              onPressed: () {
                _getCurrentPosition();
                setState(() {
                  _offStage = !_offStage;
                });
              }),
        ),
      ],
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      openAppSettings();
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
