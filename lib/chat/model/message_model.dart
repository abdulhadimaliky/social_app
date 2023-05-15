import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String messageId;
  DateTime sentAt;
  String senderId;
  String messageText;

  MessageModel({required this.messageId, required this.messageText, required this.senderId, required this.sentAt});

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "sentAt": sentAt,
        "senderId": senderId,
        "messageText": messageText,
      };

  static MessageModel fromJson(Map<String, dynamic> json) {
    return MessageModel(
        messageId: json["messageId"],
        messageText: json["messageText"],
        senderId: json["senderId"],
        sentAt: (json["sentAt"] as Timestamp).toDate());
  }
}
