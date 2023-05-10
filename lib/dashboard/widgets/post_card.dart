import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/models/post_metadata.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/repo/dashboard_repo.dart';
import 'package:social_app/dashboard/screens/comment_section.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.post,
    required this.onLiked,
  }) : super(key: key);

  final PostModel post;
  final Function(PostModel post) onLiked;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  PostMetaData? postMetaData;
  final repo = DashboardRepo();

  @override
  void initState() {
    getPostMetaData(widget.post.postId);
    super.initState();
  }

  Future<void> getPostMetaData(String postId) async {
    final postData = await repo.getPostMetaData(postId);
    if (postData.exists) {
      postMetaData = PostMetaData.fromJson(postData.data()!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
                leading: CircleAvatar(radius: 30, backgroundImage: NetworkImage(widget.post.posterImageUrl)),
                title: Text(widget.post.posterName),
                subtitle: Text(DateFormat.jm().format(widget.post.createdAt))),
            Text(widget.post.postDescription),
            const SizedBox(height: 10),
            widget.post.postImageUrl == null
                ? const SizedBox()
                : Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.227,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        widget.post.postImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const SizedBox(),
                  Row(
                    children: [
                      IconButton(
                          icon: postMetaData?.postLikesCount
                                      .contains(context.read<DashboardProvider>().currentUserData!.userUid) ??
                                  false
                              ? const Icon(Icons.thumb_up, color: Colors.black)
                              : const Icon(Icons.thumb_up_outlined, color: Colors.black),
                          onPressed: () {
                            context.read<DashboardProvider>().likePost(postMetaData!, widget.post.postId).then((value) {
                              setState(() {});
                            });
                          }),
                      const SizedBox(width: 10),
                      postMetaData == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(postMetaData?.postLikesCount.length.toString() ?? "0"),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CommentsSection(
                                postModel: widget.post,
                                postData: postMetaData!,
                              )));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.messenger_outline_rounded),
                        const SizedBox(width: 10),
                        Text(postMetaData?.postCommentsCount.toString() ?? "0"),
                      ],
                    ),
                  ),
                  const Icon(Icons.share),
                  const Icon(Icons.messenger)
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
