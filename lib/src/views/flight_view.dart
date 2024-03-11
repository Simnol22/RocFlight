import 'package:flutter/material.dart';

class FlightView extends StatefulWidget {
  const FlightView({super.key});

  static const routeName = '/flight-view';

  @override
  FlightViewState createState() => FlightViewState();
}

class FlightViewState extends State<FlightView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is the FlightView',
            ),
          ],
        ),
      ),
    );
  }
}
