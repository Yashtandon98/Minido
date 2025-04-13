import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Minido/screens/splash.dart';
import 'package:Minido/helpers/ThemeHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    // ignore: missing_required_param
    ChangeNotifierProvider<ThemeNotifier>(
     create: (context) => ThemeNotifier(),
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
    return Consumer<ThemeNotifier>(
    builder: (context, ThemeNotifier notifier, child) {
      return MaterialApp(
        title: 'Mini-Do',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(surface: Colors.white),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(surface: Colors.black),
        ),
        home: splash(),
        themeMode: notifier.darktheme ? ThemeMode.dark : ThemeMode.light,
      );
    }
    );
  }
}


