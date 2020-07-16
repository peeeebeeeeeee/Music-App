import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  bool language, logedIn, onboard;

  Future<bool> setLanguageProcessComplete(bool bol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('language', bol);
    return true;
  }

  Future<bool> getLanguageProcessComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getBool("language");
    print("$language");
    return language;
  }

  Future<bool> setLoginCompleted(bool bol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logedIn', bol);
    return true;
  }

  Future<bool> getLoginCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logedIn = prefs.getBool("logedIn");
    print("$logedIn");
    return logedIn;
  }

  Future<bool> setOnBoard(bool bol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboard', bol);
    return true;
  }

  Future<bool> getOnBoard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    onboard = prefs.getBool("onboard");
    print("$onboard");
    return onboard;
  }
}
