import 'package:flutter/material.dart';

class Shuttle extends StatelessWidget {
  // const Shuttle({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Shuttle Times'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
      );
}
