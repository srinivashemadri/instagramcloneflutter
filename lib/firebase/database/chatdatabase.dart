import 'dart:async';

import 'package:baathcheeth/firebase/database/database.dart';
import 'package:baathcheeth/models/chatinitiative.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Chat{
  String senderuid;
  String recieveruid;
  String combined;
  Chat(String s,String r)
  {
    this.senderuid = s;
    this.recieveruid = r;
    List a= new List();
    for(int i=0;i<senderuid.length;i++){
      a.add(senderuid[i]);
    }
    for(int i=0;i<recieveruid.length;i++){
      a.add(recieveruid[i]);
    }
    a.sort();
    String c='';
    for(int i=0;i<a.length;i++){
      c=c+ a[i];
    }
    this.combined = c;
  }
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  void sendmessage(Messagemodel messagemodel) async
  {
      Database(uid: senderuid).chat(recieveruid);
      Map<String, String> mm = new Map();
      mm["uid"] = messagemodel.uid;
      mm["message"] = messagemodel.message;
      mm["timestamp"] = messagemodel.timestamp;
      Map<String, String> sr = new Map();
      sr["senderuid"] = senderuid;
      sr["recieveruid"] = recieveruid;
      ref.child("chats").child(combined).push().set(mm);
  }
  DatabaseReference getref(){
    return ref.child("chats").child(combined);
  }



  
}