// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class SafetyEscort extends StatelessWidget {
  final String _call = '8182879268';
  // const SafetyEscort({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Call us for a Safety Escort'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, right: 40, left: 40, bottom: 0),
              child: Text(
                'We provide free personal safety escorts for students, faculty ,staff, and visitors from Monday-Thursday from dusk to 11:00 p.m. during the Fall and Spring semesters. You can request a safety escort by calling 818-677-5042 or 5048, from a campus phone extension 5042 or 5048. ',
                style: TextStyle(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'NOTE: A police officer is available after 11:00 p.m. all other times when the Matador Patrol is not on duty.',
                style: TextStyle(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            )),
            Divider(
                height: 50,
                thickness: 2,
                indent: 50,
                endIndent: 50,
                color: Color.fromARGB(255, 104, 104, 104)),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 40, right: 40, bottom: 10),
              child: Text(
                'When requesting a Matador Patrol escort, please provide the dispatcher with the following 4 pieces of information:',
                style: TextStyle(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 40, left: 40, bottom: 0),
              child: Text('1) Your name'),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 40, left: 40, bottom: 0),
              child: Text('2) Your location', textAlign: TextAlign.center),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 40, left: 40, bottom: 0),
              child: Text('3) Contact number'),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 40, left: 40, bottom: 0),
              child: Text('4) Your destination'),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: () async {
                  if (await canLaunch(_call)) {
                    await launch(_call);
                  }
                },
                // onPressed: () async {
                //   await FlutterPhoneDirectCaller.callNumber(
                //       SupportCallCenterNumber);
                // },
                child: Text("Call"),
              ),
            ),
          ],
        ),
      );
}
