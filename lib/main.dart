import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Minido/screens/splash.dart';
import 'package:Minido/helpers/ThemeHelper.dart';

void main() {
  runApp(
    // ignore: missing_required_param
    ChangeNotifierProvider<AppStateNotifier>(
     create: (context) => AppStateNotifier(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Random ran = new Random();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
    builder: (context, appState, child) {
      return MaterialApp(
        title: 'Mini-Do',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
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
        themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    }
    );
  }
}


