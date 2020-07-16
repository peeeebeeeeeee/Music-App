import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/Data%20Module/constants.dart';

final _firestore = Firestore.instance;

getLedgerDocumentFromCollection({final documentID}) async{
  try {
    final data = await _firestore.collection(ledgerPath)
        .document(documentID)
        .get();
    return data;
  }
  catch(error){
    return error;
  }
}

deleteLedgerDocumentFromCollection({final documentID,final context}) async{
  try{
    await _firestore.collection(ledgerPath).document(documentID).delete();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Deleted Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}

createLedgerDocumentInCollection({Ledger documentData,final context}){
  try{
   final temp= _firestore.collection(ledgerPath).add({
      'users':documentData.users,
      'lastTransactionDate':documentData.lastTransactionDate,
      'createdAt':documentData.createdAt,
      'modifiedAt':documentData.modifiedAt,
      'type':documentData.type,
      'netBalance':documentData.netBalance,
     'Config Ledgers':documentData.config
    });
    print("Created Successfully");
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    print(error);
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text(error.toString())));
  }
}

updateOneFieldLedgerDocumentInCollection({final documentID,final dataName,final data,final context}){
  try{
    _firestore.collection(ledgerPath).document(documentID).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData({
        dataName:data
      });
    });
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}

updateAllLedgerDocumentInCollection({final documentID,final context,Ledger documentData}){
  try{
    _firestore.collection(ledgerPath).document(documentID).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData({
        'users':documentData.users,
        'config':documentData.config,
        'lastTransactionDate':documentData.lastTransactionDate,
        'createdAt':documentData.createdAt,
        'modifiedAt':documentData.modifiedAt,
        'type':documentData.type,
        'netBalance':documentData.netBalance,
      });
    });
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Created Successfully')));
  }
  catch(error){
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())));
  }
}