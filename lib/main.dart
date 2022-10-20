import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'widget/navigation_drawer_widget.dart';
*/
import 'homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CSUN Navigation App',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const HomePage(title: 'CSUN Navigation App'),
      );
}
