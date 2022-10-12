import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'widget/button_widget.dart';
import 'widget/navigation_drawer_widget.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
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
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(34.24138, -118.52946);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
      ),
    ));
  }
}
