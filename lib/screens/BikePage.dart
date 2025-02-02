import 'package:flutter/material.dart';


class BikePage extends StatefulWidget {
  @override
  State<BikePage> createState() => _BikePageState();
}

class _BikePageState extends State<BikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bike Page'),
      ),
      body: Center(
        child: Text('Bike Page'),
      ),
    );
  }
}