import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Messages2 {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Messages2({
    required this.senderID,
    required this.senderEmail,
    required this.message,
    required this.receiverID,
    required this.timestamp,
    
  });
  Map<String,dynamic> toMap(){
    return{
      'senderID':senderID,
      'senderEmail':receiverID,
      'receiverID':receiverID,
      'message':message,
      'timestamp':timestamp,

    };
  }
}