class PostMetaData {
  final List<String> postLikesCount;
  int postCommentsCount;
  String postId;

  PostMetaData({required this.postCommentsCount, required this.postLikesCount, required this.postId});

  Map<String, dynamic> toJson() {
    return {"postLikeCounts": postLikesCount, "postCommentsCount": postCommentsCount, "postId": postId};
  }

  static PostMetaData fromJson(Map<String, dynamic> json) {
    return PostMetaData(
      postCommentsCount: json["postCommentsCount"],
      postLikesCount: List<String>.from(json["postLikeCounts"] ?? []),
      postId: json["postId"],
    );
  }
}
