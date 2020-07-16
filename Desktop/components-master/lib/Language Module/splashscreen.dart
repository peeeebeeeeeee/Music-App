import 'Language Screen.dart';
import 'Login Screen.dart';
import 'OnBoarding Screen.dart';
import 'package:components/Language%20Module/Shared%20Preference%20Services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Home Screen.dart';


//SplashScreenPage UI
class SplashScreen extends StatefulWidget {
  static const String id="Splash Screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Preference method = new Preference();

  //Get method of shared prefrece is called
  Future<Widget> checkScreen() async {
   
    bool islogin = await method.getLoginCompleted();
    bool islanguage = await method.getLanguageProcessComplete();
    bool isOnboard = await method.getOnBoard();

    //Cases for complete flow of module
    if (islanguage == null || !islanguage) {
      return LanguageScreen();
    } else if (islogin == null || !islogin) {
      return LoginScreen();
    } else if (isOnboard == null || !isOnboard) {
      return OnBoardingScreen();
    } else {
      return HomeScreen();
    }
  }

  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => checkScreen().then((value) => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => value))
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: new Image(
                image: new AssetImage("assets/munshiG.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
