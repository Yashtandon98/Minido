import 'dart:math';

import 'package:flutter/material.dart';
import 'package:Minido/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Random ran = new Random();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: splash(),
    );
  }
}


