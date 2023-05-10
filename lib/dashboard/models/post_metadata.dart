class PostMetaData {
  final List<String> postLikesCount;
  int postCommentsCount;

  PostMetaData({
    required this.postCommentsCount,
    required this.postLikesCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "postLikeCounts": postLikesCount,
      "postCommentsCount": postCommentsCount,
    };
  }

  static PostMetaData fromJson(Map<String, dynamic> json) {
    return PostMetaData(
      postCommentsCount: json["postCommentsCount"],
      postLikesCount: List<String>.from(json["postLikeCounts"] ?? []),
    );
  }
}
