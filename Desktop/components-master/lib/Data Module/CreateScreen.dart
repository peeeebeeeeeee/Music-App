import 'Firestore%20Data%20Services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class CreateFormScreen extends StatefulWidget {
  static const String id='Form Screen';
  @override
  CreateFormScreenState createState() {
    return CreateFormScreenState();
  }
}

class CreateFormScreenState extends State<CreateFormScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,),
        body:MyCustomForm(),
      ),
    );
  }
}
class MyCustomForm extends StatefulWidget {
  MyCustomForm({this.details});
  final details;
  @override
  CreateForm createState() {
    return CreateForm();
  }
}

class CreateForm extends State<MyCustomForm> {

  String name,phno;
  DateTime currentTime;
  var hobbies=new List(2);
  bool isMale;
  String dropdownvalue;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
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
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Hobby No.1',
              ),
              onChanged: (value){
                hobbies[0]=value.toString();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Hobby No.2',
              ),
              onChanged: (value){
                hobbies[1]=value.toString();
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
                    Map documentData={
                      'Name': name,
                      'Phone no': phno,
                      'Hobbies': hobbies,
                      'Created Time': currentTime,
                      'isMale': isMale,
                    };
                    documentData=new Map<String, dynamic>.from(documentData);
                    createDocumentInCollection(collectionName: 'Data Module Test', documentData :documentData,context: context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
