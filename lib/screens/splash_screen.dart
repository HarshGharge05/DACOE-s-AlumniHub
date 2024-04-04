import 'package:alumniapp/screens/feed_screen.dart';
import 'package:alumniapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          SizedBox(height: 200,),
          Image.asset('lib/images/DACOE.png', height: 250, width: 400,),
          //welcome back to DACOE
          Text('Welcome back to DACOE!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, color: Colors.black, letterSpacing: .5, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
          ),

          SizedBox(height: 100,),
          Text("@Made by DACOE's CSE Students!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: Colors.grey, fontWeight: FontWeight.normal)
          ),

        ])
    );
  }
}
