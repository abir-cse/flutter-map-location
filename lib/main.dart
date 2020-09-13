import 'package:flutter/material.dart';
import 'MapScreen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return SafeArea(
      child: MaterialApp(
        home: MapScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


