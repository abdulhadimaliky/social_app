import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

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

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.postModel});

  final PostModel postModel;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController controller = TextEditingController();

  List<Comment> comments = [];

  @override
  void initState() {
    openCommentsStream().listen((event) {
      comments = event;
    });
    super.initState();
  }

  Stream<List<Comment>> openCommentsStream() {
    return FirebaseFirestore.instance
        .collection("akdsf")
        .snapshots()
        .map((event) => event.docs.map((e) => Comment.fromJson(e.data())).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comment Section")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.postModel.postId)
                          .collection("comments")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {}
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text("No stream opened");

                          case ConnectionState.waiting:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            final docs = snapshot.data!.docs;
                            log("REBUILDING");
                            if (docs.isEmpty) {
                              return const Text("Such an empty comment section");
                            }
                            final commentsModels = docs.map((e) => Comment.fromJson(e.data())).toList();
                            return ListView.builder(
                                itemCount: commentsModels.length,
                                itemBuilder: (context, index) {
                                  final comment = commentsModels[index];
                                  return ListTile(
                                    title: Text(comment.text),
                                    trailing: Text(comment.commentAt.toString()),
                                  );
                                });

                          case ConnectionState.done:
                            return const SizedBox();
                        }
                      })),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.postModel.postId)
                          .collection("comments")
                          .add(Comment(commentAt: DateTime.now(), text: controller.text).toJson())
                          .then((value) => controller.clear());
                    },
                    icon: const Icon(Icons.send, color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
