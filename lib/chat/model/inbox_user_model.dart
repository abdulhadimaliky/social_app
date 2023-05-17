import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/chat/model/message_model.dart';

class InboxUserModel {
  String inboxId;
  InboxUser inboxUser;
  MessageModel lastMessage;
  DateTime lastOpenedByUserAt;
  DateTime lastUpdatedAt;

  InboxUserModel({
    required this.inboxId,
    required this.inboxUser,
    required this.lastMessage,
    required this.lastOpenedByUserAt,
    required this.lastUpdatedAt,
  });

  Map<String, dynamic> toJson() => {
        "inboxId": inboxId,
        "inboxUser": inboxUser.toJson(),
        "lastMessage": lastMessage.toJson(),
        "lastOpenedByUserAt": lastOpenedByUserAt,
        "lastUpdatedAt": lastUpdatedAt,
      };

  factory InboxUserModel.fromJson(Map<String, dynamic> json) {
    return InboxUserModel(
      inboxId: json["inboxId"],
      inboxUser: InboxUser.fromJson(json["inboxUser"]),
      lastMessage: MessageModel.fromJson(json["lastMessage"]),
      lastOpenedByUserAt: (json["lastOpenedByUserAt"] as Timestamp).toDate(),
      lastUpdatedAt: (json["lastUpdatedAt"] as Timestamp).toDate(),
    );
  }
}

class InboxUser {
  String userName;
  String? userProfileUrl;
  String userId;

  InboxUser({
    required this.userName,
    required this.userProfileUrl,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {"userName": userName, "userProfileUrl": userProfileUrl, "userId": userId};

  factory InboxUser.fromJson(Map<String, dynamic> json) {
    return InboxUser(
      userName: json["userName"],
      userProfileUrl: json["userProfileUrl"],
      userId: json["userId"],
    );
  }
}
