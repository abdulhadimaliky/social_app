import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String text;
  DateTime commentAt;

  Comment({
    required this.text,
    required this.commentAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        text: json["text"],
        commentAt: (json["commentAt"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "commentAt": commentAt,
      };
}
