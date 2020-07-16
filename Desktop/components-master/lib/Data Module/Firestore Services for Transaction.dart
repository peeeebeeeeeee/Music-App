import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/Data%20Module/constants.dart';

final _firestore = Firestore.instance;

getTransactionDocumentFromCollection({final documentID}) async{
  try {
    final data = await _firestore.collection(transactionPath).document(
        documentID).get();
    return data;
  }
  catch(error){
    return error;
  }
}

deleteTransactionDocumentFromCollection({final documentID,final context}) async{
  try{
    await _firestore.collection(transactionPath).document(documentID).delete();
    print("Created Successfully");
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text('Deleted Successfully')));
  }
  catch(error){
    print(error.toString());
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text(error.toString())));
  }
}

createTransactionDocumentInCollection({Transactions documentData,final context}){
  try{
    _firestore.collection(transactionPath).add({
      'creatorUserId': documentData.creatorUserId,
      'notes': documentData.notes,
      'operation': documentData.operation,
      'ledgerID': documentData.ledgerID,
      'referenceTransactionID': documentData.referenceTransactionID,
      'url': documentData.url,
      'paymentAmount': documentData.paymentAmount,
      'date': documentData.date,
      'createdAt': documentData.createdAt,
      'modifiedAt': documentData.modifiedAt,
      'remindOn': documentData.remindOn,
      'isCancelled': documentData.isCancelled,
      'openingBalance': documentData.openingBalance,
      'remind': documentData.remind,
      'type': documentData.type,
      'subType': documentData.subType,
      'category': documentData.category,
      'cancelationReasons': documentData.cancelationReasons,
      'reminder': documentData.reminder,
      'images': documentData.images
    });
    print("Created Successfully");
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    print(error.toString());
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text(error.toString())));
  }
}

updateOneTransactionlDocumentInCollection({final documentID,final dataName,final data,final context}){
  try{
    _firestore.collection(transactionPath).document(documentID).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData({
        dataName:data
      });
    });
    print("Created Successfully");
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    print(error.toString());
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text(error.toString())));
  }
}

updateTransactionDocumentInCollection({final documentID,final context,Transactions documentData}){
  try{
    _firestore.collection(transactionPath).document(documentID).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData({
        'creatorUserId': documentData.creatorUserId,
        'notes': documentData.notes,
        'operation': documentData.operation,
        'ledgerID': documentData.ledgerID,
        'referenceTransactionID': documentData.referenceTransactionID,
        'url': documentData.url,
        'paymentAmount': documentData.paymentAmount,
        'date': documentData.date,
        'createdAt': documentData.createdAt,
        'modifiedAt': documentData.modifiedAt,
        'remindOn': documentData.remindOn,
        'isCancelled': documentData.isCancelled,
        'openingBalance': documentData.openingBalance,
        'remind': documentData.remind,
        'type': documentData.type,
        'subType': documentData.subType,
        'category': documentData.category,
        'cancelationReasons': documentData.cancelationReasons,
        'reminder': documentData.reminder,
        'images': documentData.images
      });
    });
    print("Created Successfully");
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    print(error.toString());
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text(error.toString())));
  }
}