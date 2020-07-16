import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
var tempDocumentData;

getDocumentFromCollection({final collectionName, final documentID}) async{
  final data= await _firestore.collection(collectionName).document(documentID).get();
  return data;
}

deleteDocumentFromCollection({final collectionName, final documentID,final context}) async{
  try{
    await _firestore.collection(collectionName).document(documentID).delete();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Deleted Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}

createDocumentInCollection({final collectionName,final documentData,final context}){
  try{
    _firestore.collection('Data Module Test').add(documentData);
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}

updateDocumentInCollection({final collectionName,final documentData,final context,Map data}){
  try{
     _firestore.collection('Data Module Test').document(documentData).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData(data);
    });
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}