class PostModel {
  final String postTitle;
  final String postDescription;
  final String postUserId;
  final String postId;
  final int postLikes;
  final int postComments;

  PostModel({
    required this.postComments,
    required this.postDescription,
    required this.postId,
    required this.postLikes,
    required this.postTitle,
    required this.postUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      "postTitle": postTitle,
      "postDescription": postDescription,
      "postUserId": postUserId,
      "postId": postId,
      "postLikes": postLikes,
      "postComments": postComments
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
    );
  }
}
