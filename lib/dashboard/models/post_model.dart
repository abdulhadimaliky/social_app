import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postTitle;
  final String postDescription;
  final String postUserId;
  final String postId;
  final String posterName;
  final String posterImageUrl;

  final DateTime createdAt;

  final String? postImageUrl;

  PostModel({
    required this.postDescription,
    required this.postId,
    required this.postTitle,
    required this.postUserId,
    required this.posterImageUrl,
    required this.createdAt,
    required this.posterName,
    required this.postImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "postTitle": postTitle,
      "postDescription": postDescription,
      "postUserId": postUserId,
      "postId": postId,
      "posterImageUrl": posterImageUrl,
      "posterName": posterName,
      "createdAt": createdAt,
      "postImageUrl": postImageUrl
    };
  }

  static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      postDescription: json["postDescription"],
      postId: json["postId"],
      postTitle: json["postTitle"],
      postUserId: json["postUserId"],
      posterImageUrl: json["posterImageUrl"],
      posterName: json["posterName"],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      postImageUrl: json["postImageUrl"],
    );
  }
}
