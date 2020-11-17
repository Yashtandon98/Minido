import 'package:flutter/material.dart';
import 'dart:async';
import 'MiniDoScreen.dart';


class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starter();
  }

  starter() async {
    var d = new Duration(milliseconds: 2000);
    return new Timer(d, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MiniDoScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/4.5,
          height: MediaQuery.of(context).size.width/4.5,
          decoration: BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/icon.png'),
                  fit: BoxFit.fill
              )
          ),
        ),
      ),
    );
  }
}
