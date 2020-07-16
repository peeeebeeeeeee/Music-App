import 'package:cloud_firestore/cloud_firestore.dart';
import 'CreateScreen.dart';
import 'RetrieveScreen.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

class ListScreen extends StatefulWidget {
  static const String id='List Screen';
  @override
  ListScreenState createState() {
    return ListScreenState();
  }
}

class ListScreenState extends State<ListScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Icon(Icons.plus_one,size: 40,),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateFormScreen(),
                    ));
              },
            ),
          ],
        ),
        body: TextCatalogue(),
      ),
    );
  }
}

class TextCatalogue extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Data Module Test').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final details = snapshot.data.documents;
        print("details : $details");
        List<Cards> textCatalogue = [];
        for (var detail in details) {
          Cards textDesigns;
          if(detail['Name']!=null)
          textDesigns = Cards(
              title:detail['Name'],
              onPressed:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DisplayScreen(details: detail.documentID),
                    ));
              }
          );
          textCatalogue.add(textDesigns);
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: textCatalogue,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  Cards({this.title,@required this.onPressed});
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:10.0),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5.0,
        color: Colors.white,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 80.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Icon(Icons.account_circle,color: Colors.black87,size: 50,),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}