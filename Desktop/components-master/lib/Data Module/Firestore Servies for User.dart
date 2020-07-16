import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/Data%20Module/constants.dart';

final _firestore = Firestore.instance;

getUserDocumentFromCollection({final documentID}) async{
  try {
    final data = await _firestore.collection(userPath)
        .document(documentID)
        .get();
    return data;
  }
  catch(error){
   return error;
  }
}

deleteUserDocumentFromCollection({final documentID,final context}) async{
  try{
    await _firestore.collection(userPath).document(documentID).delete();
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

createUserDocumentInCollection({User documentData,final context}){
  try{
    _firestore.collection(userPath).add({
    'name': documentData.name,
    'phoneNumber': documentData.phoneNumber,
    'versionName': documentData.versionName,
    'address': documentData.address,
    'latitude': documentData.latitude,
    'longitude': documentData.longitude,
    'referral': documentData.referral,
    'createdAt': documentData.createdAt,
    'lastOpenedAt': documentData.lastOpenedAt,
    'lastSignInAt': documentData.lastSignInAt,
    'versionCode': documentData.versionCode,
    'businessType': documentData.businessType
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

updateOneUserlDocumentInCollection({final documentID,final dataName,final data,final context}){
  try{
    _firestore.collection(userPath).document(documentID).get().then((value){
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

updateUserDocumentInCollection({final documentID,final context,User documentData}){
  try{
    _firestore.collection(userPath).document(documentID).get().then((value){
      print("Value ${value.data}");
      value.reference.updateData({
        'name': documentData.name,
        'phoneNumber': documentData.phoneNumber,
        'versionName': documentData.versionName,
        'address': documentData.address,
        'latitude': documentData.latitude,
        'longitude': documentData.longitude,
        'referral': documentData.referral,
        'createdAt': documentData.createdAt,
        'lastOpenedAt': documentData.lastOpenedAt,
        'lastSignInAt': documentData.lastSignInAt,
        'versionCode': documentData.versionCode,
        'businessType': documentData.businessType
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