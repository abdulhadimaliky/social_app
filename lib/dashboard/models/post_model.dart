import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postTitle;
  final String postDescription;
  final String postUserId;
  final String postId;
  final String posterName;
  final String posterImageUrl;
  final int postComments;
  final DateTime createdAt;
  final List<String> likedBy;
  final String? postImageUrl;

  PostModel(
      {required this.postComments,
      required this.postDescription,
      required this.postId,
      required this.likedBy,
      required this.postTitle,
      required this.postUserId,
      required this.posterImageUrl,
      required this.createdAt,
      required this.posterName,
      required this.postImageUrl});

  Map<String, dynamic> toJson() {
    return {
      "postTitle": postTitle,
      "postDescription": postDescription,
      "postUserId": postUserId,
      "postId": postId,
      "likedBy": likedBy,
      "postComments": postComments,
      "posterImageUrl": posterImageUrl,
      "posterName": posterName,
      "createdAt": createdAt,
      "postImageUrl": postImageUrl
    };
  }

  static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      postComments: json["postComments"],
      postDescription: json["postDescription"],
      postId: json["postId"],
      likedBy: List<String>.from(json["likedBy"] ?? []),
      postTitle: json["postTitle"],
      postUserId: json["postUserId"],
      posterImageUrl: json["posterImageUrl"],
      posterName: json["posterName"],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      postImageUrl: json["postImageUrl"],
    );
  }
}
