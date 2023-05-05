import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postTitle;
  final String postDescription;
  final String postUserId;
  final String postId;
  final int postLikes;
  final String posterName;
  final String posterImageUrl;
  final int postComments;
  final DateTime createdAt;

  PostModel({
    required this.postComments,
    required this.postDescription,
    required this.postId,
    required this.postLikes,
    required this.postTitle,
    required this.postUserId,
    required this.posterImageUrl,
    required this.createdAt,
    required this.posterName,
  });

  Map<String, dynamic> toJson() {
    return {
      "postTitle": postTitle,
      "postDescription": postDescription,
      "postUserId": postUserId,
      "postId": postId,
      "postLikes": postLikes,
      "postComments": postComments,
      "posterImageUrl": posterImageUrl,
      "posterName": posterName,
      "createdAt": createdAt
    };
  }

  static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      postComments: json["postComments"],
      postDescription: json["postDescription"],
      postId: json["postId"],
      postLikes: json["postLikes"],
      postTitle: json["postTitle"],
      postUserId: json["postUserId"],
      posterImageUrl: json["posterImageUrl"],
      posterName: json["posterName"],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
