import 'Home Screen.dart';
import 'package:components/Language%20Module/Shared%20Preference%20Services.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

//IntroPage UI
class OnBoardingScreen extends StatefulWidget {
  static const String id="Onboarding Screen";
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // final method = Preference().checkScreen();
  Preference method = new Preference();

  //List of all the pages of Introduction screen
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/1.png"),
          title: "Page 1",
          body: "Welcome to First Page",
          decoration: const PageDecoration()),
      PageViewModel(
        image: Image.asset("assets/2.png"),
        title: "Page 2 ",
        body: "Welcome to Second Page",
      ),
      PageViewModel(
        image: Image.asset("assets/3.png"),
        title: "Page 3",
        body: "Welcome to third Page",
      ),
      PageViewModel(
        image: Image.asset("assets/2.png"),
        title: " Page 4 ",
        body: "Welcome to Fourth Page",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Align(
            alignment: Alignment.center,
            child: IntroductionScreen(
              globalBackgroundColor: Colors.white,
              pages: getPages(),
              showNextButton: true,
              showSkipButton: true,
              skip: Text(
                  "Skip"), //on skip press direct head to final page of Introduction
              next: Text("Next"), //on next pressed page moves one by one
              done: Text("Done "), //on done press we moved to Destination page
              onDone: () async {
                //use of shared prefernce

                method.setOnBoard(true);
                Navigator.pushNamed(context, HomeScreen.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
