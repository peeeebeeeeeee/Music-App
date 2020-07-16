import 'package:flutter/material.dart';

String userPath='User',transactionPath='Transactions',ledgerPath='Ledger';

class User{
  String name,phoneNumber,versionName,address;
  double latitude;
  double longitude;
  String referral;
  DateTime createdAt,lastOpenedAt,lastSignInAt;
  int versionCode,businessType;
  User({String name,String phoneNumber,String versionName,String address,double latitude, double longitude, String referral,
    DateTime createdAt,DateTime lastOpenedAt,DateTime lastSignInAt,int versionCode,int businessType}){
    this.name=name;
    this.phoneNumber=phoneNumber;
    this.versionName=versionName;
    this.address=address;
    this.latitude=latitude;
    this.longitude=longitude;
    this.referral=referral;
    this.createdAt=createdAt;
    this.lastOpenedAt=lastOpenedAt;
    this.lastSignInAt=lastSignInAt;
    this.versionCode=versionCode;
    this.businessType=businessType;
  }
}

class Transactions{
  String creatorUserId,notes,operation,ledgerID,referenceTransactionID,url;
  double paymentAmount;
  DateTime date,createdAt,modifiedAt,remindOn;
  bool isCancelled,openingBalance,remind;
  int type,subType,category;
  List<int> cancelationReasons;
  Map<String,Map<String,dynamic>> reminder;
  Map<String,Map<String,dynamic>> images;
  Transactions({String creatorUserId,String notes,String operation,String ledgerID,String referenceTransactionID,String url,double paymentAmount,
    DateTime date,DateTime createdAt,DateTime modifiedAt,DateTime remindOn, bool isCancelled,bool openingBalance,bool remind, int type,int subType,int category,
    List<int> cancelationReasons,Map<String,Map<String,dynamic>> reminder,Map<String,Map<String,dynamic>> images}){
    this.creatorUserId=creatorUserId;
    this.notes=notes;
    this.operation=operation;
    this.ledgerID=ledgerID;
    this.referenceTransactionID=referenceTransactionID;
    this.url=url;
     this.paymentAmount;
    this.date=date;
    this.createdAt=createdAt;
    this.modifiedAt=modifiedAt;
    this.remindOn=remindOn;
    this.isCancelled=isCancelled;
    this.openingBalance=openingBalance;
    this.remind=remind;
    this.type=type;
    this.subType=subType;
    this.category=category;
    this.cancelationReasons=cancelationReasons;
    this.reminder=reminder;
    this.images=images;
  }
}

class ImageObject{
  String path,thumbnail;
}

class TxnReminder{
  bool remind;
  DateTime remindOn;
}

class Ledger{
  List<String> users;
  Map<String,Map<String,dynamic>> config;
  DateTime lastTransactionDate,createdAt,modifiedAt;
  int type;
  double netBalance;
  Ledger({List<String> users,Map<String,Map<String,dynamic>> config,DateTime lastTransactionDate,DateTime createdAt,DateTime modifiedAt, int type,double netBalance}){
    this.users=users;
    this.config=config;
    this.lastTransactionDate=lastTransactionDate;
    this.createdAt=createdAt;
    this.modifiedAt=modifiedAt;
    this.type=type;
    this.netBalance=netBalance;
  }
}


class ConfigLedger{
  String label;
  bool creator,sendSMS,archieved,deleted;
  ConfigLedger({String label,bool creator,bool sendSMS,bool archieved,bool deleted}){
    this.label=label;
    this.creator=creator;
    this.sendSMS=sendSMS;
    this.archieved=archieved;
    this.deleted=deleted;
  }
}