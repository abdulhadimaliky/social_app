import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/common/services/id_service.dart';
import 'package:social_app/dashboard/models/post_model.dart';

class DashboardRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getRecommendations() async {
    final getRecs = await FirebaseFirestore.instance
        .collection("userData")
        .where("userUid", isNotEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    return getRecs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final getRecs = await FirebaseFirestore.instance.collection("userData").doc(firebaseAuth.currentUser!.uid).get();

    return getRecs;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
  //   final receivedUser = await firestore.collection("userData").doc(id).get();
  //   return receivedUser;
  // }

  Future<void> submitPost(
    int postComments,
    String postDescription,
    int postLikes,
    String postTitle,
    String posterImageUrl,
    String posterName,
  ) async {
    final myPostId = IdService.generateId();
    final post = PostModel(
      postComments: postComments,
      postDescription: postDescription,
      postId: myPostId,
      postLikes: postLikes,
      postTitle: postTitle,
      postUserId: firebaseAuth.currentUser!.uid,
      posterImageUrl: posterImageUrl,
      posterName: posterName,
      createdAt: DateTime.now(),
    );
    await firestore.collection("Posts").doc(myPostId).set(post.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyPostsFromDB() async {
    final getMyPosts = await firestore
        .collection("Posts")
        .where("postUserId", isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .get();

    return getMyPosts;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPosts() async {
    final getAllPosts = await firestore.collection("Posts").orderBy("createdAt", descending: true).get();
    return getAllPosts;
  }
}
