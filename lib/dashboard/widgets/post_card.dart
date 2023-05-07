import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/comment_section.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.post,
    required this.onLiked,
  }) : super(key: key);

  final PostModel post;
  final Function(PostModel post) onLiked;

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
                leading: CircleAvatar(radius: 30, backgroundImage: NetworkImage(post.posterImageUrl)),
                title: Text(post.posterName),
                subtitle: Text(DateFormat.jm().format(post.createdAt))),
            Text(post.postDescription),
            const SizedBox(height: 10),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.227,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: post.postImageUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(post.postImageUrl!),
                          fit: BoxFit.cover,
                        ),
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
                          icon: post.likedBy.contains(context.read<DashboardProvider>().currentUserData!.userUid)
                              ? const Icon(Icons.thumb_up, color: Colors.black)
                              : const Icon(Icons.thumb_up_outlined, color: Colors.black),
                          onPressed: () {
                            onLiked(post);
                          }),
                      const SizedBox(width: 10),
                      Text(post.likedBy.length.toString()),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => CommentsSection(postModel: post)));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.messenger_outline_rounded),
                        const SizedBox(width: 10),
                        Text(post.postComments.toString()),
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
