import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'RetrieveScreen.dart';
import 'Firestore Data Services.dart';

TextEditingController controllerName,controllerHobby1,controllerHobby2,controllerPhNo;
var previoushobbies;
String previousName, previousPhNo;
bool previousIsMale;

class EditFormScreen extends StatefulWidget {
  static const String id='Edit Form Screen';
  EditFormScreen({this.details});
  final details;

  @override
  EditFormScreenState createState() {
    return EditFormScreenState();
  }
}

class EditFormScreenState extends State<EditFormScreen> {


  @override
  Widget build(BuildContext context) {
    print(widget.details);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,),
        body:FutureBuilder(
          future: getDocumentFromCollection(collectionName:'Data Module Test', documentID:widget.details),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            List<Widget> children;
            if (snapshot.hasData) {
              previousName=snapshot.data['Name'];
              previousPhNo=snapshot.data['Phone no'];
              previoushobbies=snapshot.data['Hobbies'];
              previousIsMale==snapshot.data['isMale'];
              controllerName = TextEditingController(text: previousName);
              controllerHobby1 = TextEditingController(text: previoushobbies[0]);
              controllerHobby2 = TextEditingController(text: previoushobbies[1]);
              controllerPhNo= TextEditingController(text: previousPhNo);

              children = <Widget>[
                MyCustomForm(details: widget.details,),
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
                children: children
              ),
            );
          },
        ),
      ),
    );
  }
}
class MyCustomForm extends StatefulWidget {
  MyCustomForm({this.details});
  final details;
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  String name=previousName,phno=previousPhNo;
  DateTime currentTime;
  var hobbies = previoushobbies;
  bool isMale=previousIsMale;
  String dropdownvalue;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: controllerName,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            onChanged: (value){
              name=value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          DropdownButton<String>(
            value: dropdownvalue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.grey),
            underline: Container(
              height: 2,
              color: Colors.grey,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownvalue = newValue;
                isMale=(dropdownvalue=='Male')?true:false;
              });
            },
            items: <String>['Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextFormField(
            controller: controllerPhNo,
            inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
            keyboardType: TextInputType.numberWithOptions(),
            decoration: const InputDecoration(
              labelText: 'Phone number',
            ),
            onChanged: (value){
              phno=value;
            },
            validator: (value) {
              if (value.toString().length!=10) {
                return 'Please entera valid phone number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: controllerHobby1,
            decoration: const InputDecoration(
              labelText: 'Hobby No.1',
            ),
            onChanged: (value){
              hobbies[0]=value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: controllerHobby2,
            decoration: const InputDecoration(
              labelText: 'Hobby No.2',
            ),
            onChanged: (value){
              hobbies[1]=value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: (){
                if (_formKey.currentState.validate()) {
                  currentTime = DateTime.now();
                  Map data = {
                    'Name': name,
                    'Phone no': phno,
                    'Hobbies': hobbies,
                    'Created Time': currentTime,
                    'isMale': isMale,
                  };
                  data=new Map<String, dynamic>.from(data);
                  updateDocumentInCollection(collectionName:'Data Module Test', documentData:widget.details, context:context,data: data);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
