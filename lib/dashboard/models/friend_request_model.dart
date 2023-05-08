import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  String senderId;
  String receiverId;
  DateTime sentAt;
  String senderImageUrl;
  String senderName;

  FriendRequestModel({
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    required this.senderImageUrl,
    required this.senderName,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) => FriendRequestModel(
      senderId: json["senderId"],
      sentAt: (json["sentAt"] as Timestamp).toDate(),
      senderImageUrl: json["senderImageUrl"],
      senderName: json["senderName"],
      receiverId: json["receiverId"]);

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "sentAt": sentAt,
        "senderImageUrl": senderImageUrl,
        "senderName": senderName,
        "receiverId": receiverId,
      };
}
