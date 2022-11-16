import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderID;
  String? receiverID;
  String? type;
  String? message;
  FieldValue? timestamp;
  String? imageURL;

  Message({
    this.senderID,
    this.receiverID,
    this.type,
    this.message,
    this.timestamp,
  });

  Message.imageMessage({
    this.senderID,
    this.receiverID,
    this.type,
    this.imageURL,
    this.timestamp,
  });

  Map toMap() {
    var map = <String, dynamic>{};
    map['senderID'] = senderID;
    map['receiverID'] = receiverID;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> mapData) {
    senderID = mapData['senderID'];
    receiverID = mapData['receiverID'];
    type = mapData['type'];
    message = mapData['message'];
    timestamp = mapData['timestamp'];
    return this;
  }
}
