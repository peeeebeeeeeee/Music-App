import 'package:flutter/material.dart';
import 'UpdateScreen.dart';
import 'Firestore Data Services.dart';

class DisplayScreen extends StatefulWidget {
  static const String id='Display Screen';
  DisplayScreen({this.details});
  final details;
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.details);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          Row(
            children: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Icon(Icons.delete,size: 30,),
                onPressed: (){
                  deleteDocumentFromCollection(collectionName:'Data Module Test', documentID:widget.details);
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child:  Icon(Icons.edit,size: 30,),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditFormScreen(details:widget.details),
                      ));
                },
              )
            ],
          )
        ],
      ),
      body:FutureBuilder(
        future: getDocumentFromCollection(collectionName:'Data Module Test',documentID: widget.details) , // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
             children: <Widget>[
               Fields(title: "Name",input: snapshot.data['Name'],),
               Fields(title: "Phone no",input: snapshot.data['Phone no'],),
               Fields(title: "Gender",input: snapshot.data['isMale'],),
               Fields(title: "Hobby No1",input: snapshot.data['Hobbies'][0]),
               Fields(title: "Hobby No2",input: snapshot.data['Hobbies'][1]),
               Fields(title: "Time",input: snapshot.data['Created Time'].toDate().toString(),),
               ],
          ),
          ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
 class Fields extends StatelessWidget {

  Fields({this.title,this.input});
  final input,title;

   @override
   Widget build(BuildContext context) {
     return Row(
       children: <Widget>[
         Expanded(flex:1,child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(title),
         )),
         Expanded(
           flex: 4,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               decoration: BoxDecoration(
                   border: Border.all(width: 1)
               ),
               height: 30,
               child: Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: Text(" $input",style: TextStyle(fontSize: 18),),
               ),
             ),
           ),
         ),
       ],
     );
   }
 }
