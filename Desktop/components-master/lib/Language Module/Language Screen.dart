import 'Login Screen.dart';
import 'package:components/Language%20Module/Shared%20Preference%20Services.dart';
import 'package:flutter/material.dart';

//Language Page
class LanguageScreen extends StatefulWidget {
  static const String id='Language Screen';
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Preference method = new Preference();

  //List of Language name
  List<String> names = [
    'Hinglish',
    'English',
    'Hindi',
    'Urdu',
    'Tamil',
    'Telegu',
    'Marathi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                //Translator Icon used
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 14, top: 15, bottom: 5),
                    child: Icon(
                      Icons.g_translate,
                      size: 75.0,
                    ),
                  ),
                ),

                //for heading
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 13, bottom: 2),
                    child: Text(
                      "Choose Your Preferred Language",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 13.0,
                      top: 2,
                      bottom: 4,
                    ),
                    child: Text(
                      "Select your Language",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),

                //Used to make list
                Flexible(
                  child: ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (_, int index) {
                        return OptionList("${names[index]}");
                      }),
                ),

                //Button in a container
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10.0),
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id); //Navigation to new page
                    },
                    color: Colors.blue,
                    child: Text(
                      "Lets Get Started ->",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

//OptionList class which defines the features of above Language list.
class OptionList extends StatefulWidget {
  final String language;
  OptionList(this.language);

  @override
  _OptionListState createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  Preference method = new Preference();

  //function defined for Language list
  void openLoginPage() async {
   //setting Shared Pref value
    method.setLanguageProcessComplete(true);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(widget.language[0]),
      ),
      title: Text(widget.language),
      onTap: () {
        openLoginPage();
      },
    );
  }
}
