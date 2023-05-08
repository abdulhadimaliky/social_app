import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String text;
  DateTime commentAt;
  String commenterImageUrl;
  String commenterName;

  Comment({
    required this.text,
    required this.commentAt,
    required this.commenterImageUrl,
    required this.commenterName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        text: json["text"],
        commentAt: (json["commentAt"] as Timestamp).toDate(),
        commenterImageUrl: json["commenterImageUrl"],
        commenterName: json["commenterName"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "commentAt": commentAt,
        "commenterImageUrl": commenterImageUrl,
        "commenterName": commenterName,
      };
}
