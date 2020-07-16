import 'package:components/Data%20Module/RetrieveScreen.dart';
import 'package:components/Language Module/splashscreen.dart';
import 'package:components/Language Module/OnBoarding Screen.dart';
import 'package:components/Language Module/Home Screen.dart';
import 'package:flutter/material.dart';
import 'package:components/Language Module/Login Screen.dart';
import 'package:components/Language Module/Language Screen.dart';
import 'package:components/imageModule/screen.dart';

void main()=>runApp(MyApp());

class  MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        OnBoardingScreen.id:(context)=>OnBoardingScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LanguageScreen.id:(context)=>LanguageScreen(),
        ImageScreen.id:(context)=>ImageScreen(),
        DisplayScreen.id:(context)=>DisplayScreen(),
      },
    );
  }
}
