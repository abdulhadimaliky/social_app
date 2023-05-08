import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  String requestId;
  String senderId;
  String receiverId;
  DateTime sentAt;
  String senderImageUrl;
  String senderName;
  RequestStatus requestStatus;

  FriendRequestModel(
      {required this.senderId,
      required this.receiverId,
      required this.sentAt,
      required this.senderImageUrl,
      required this.senderName,
      required this.requestId,
      required this.requestStatus});

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) => FriendRequestModel(
        senderId: json["senderId"],
        sentAt: (json["sentAt"] as Timestamp).toDate(),
        senderImageUrl: json["senderImageUrl"],
        senderName: json["senderName"],
        receiverId: json["receiverId"],
        requestId: json["requestId"],
        requestStatus: RequestStatus.values.firstWhere((element) => element.name == (json["requestStatus"] as String)),
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "sentAt": sentAt,
        "senderImageUrl": senderImageUrl,
        "senderName": senderName,
        "receiverId": receiverId,
        "requestId": requestId,
        "requestStatus": requestStatus.name
      };
}

enum RequestStatus {
  pending,
  accepted,
}
