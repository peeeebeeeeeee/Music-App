import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id="Home Screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(  "Login",
    textAlign: TextAlign.center,)
      ),
      body:Center(
        child: Text("Login Page"),
      )
    );
  }
}