import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/common/services/id_service.dart';
import 'package:social_app/dashboard/models/comment_model.dart';
import 'package:social_app/dashboard/models/friend_request_model.dart';
import 'package:social_app/dashboard/models/post_model.dart';

class DashboardRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getRecommendations() async {
    final getRecs =
        await firestore.collection("userData").where("userUid", isNotEqualTo: firebaseAuth.currentUser!.uid).get();

    return getRecs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final getRecs = await firestore.collection("userData").doc(firebaseAuth.currentUser!.uid).get();

    return getRecs;
  }

  Future<String?> uploadPostImage(XFile? file) async {
    print(file);
    if (file != null) {
      final task = await firebaseStorage.ref("postImageUrl/${file.name}").putFile(File(file.path));
      final url = await task.ref.getDownloadURL();
      print(url);
      return url;
    }
    return null;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
  //   final receivedUser = await firestore.collection("userData").doc(id).get();
  //   return receivedUser;
  // }

  Future<void> submitPost(
    int postComments,
    String postDescription,
    List<String> likedBy,
    String postTitle,
    String posterImageUrl,
    String posterName,
    XFile? file,
  ) async {
    final myPostId = IdService.generateId();
    final post = PostModel(
      postComments: postComments,
      postDescription: postDescription,
      postId: myPostId,
      likedBy: likedBy,
      postTitle: postTitle,
      postUserId: firebaseAuth.currentUser!.uid,
      posterImageUrl: posterImageUrl,
      posterName: posterName,
      createdAt: DateTime.now(),
      postImageUrl: await uploadPostImage(file),
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

  Future<void> likePost(PostModel post, String userId) async {
    await firestore.collection("Posts").doc(post.postId).update({
      "likedBy": FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unlikePost(PostModel post, String userId) async {
    await firestore.collection("Posts").doc(post.postId).update({
      "likedBy": FieldValue.arrayRemove([userId])
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserPostsFromDB(String posterId) async {
    final getMyPosts = await firestore
        .collection("Posts")
        .where("postUserId", isEqualTo: posterId)
        .orderBy("createdAt", descending: true)
        .get();

    return getMyPosts;
  }

  Future<void> addComment(String postId, String commentBody, String commenterImageUrl, String commenterName) async {
    await FirebaseFirestore.instance.collection("Posts").doc(postId).collection("comments").add(Comment(
            commentAt: DateTime.now(),
            text: commentBody,
            commenterImageUrl: commenterImageUrl,
            commenterName: commenterName)
        .toJson());
    await firestore.collection("Posts").doc(postId).update({"postComments": FieldValue.increment(1)});
  }

  Stream<List<Comment>> openCommentsStream(String postId) {
    return firestore
        .collection("Posts")
        .doc(postId)
        .collection("comments")
        .orderBy("commentAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Comment.fromJson(e.data())).toList());
  }

  Future<void> sendRequest(
    String senderId,
    String receiverId,
    DateTime sentAt,
    String senderImageUrl,
    String senderName,
  ) async {
    final requestId = IdService.generateId();
    final request = FriendRequestModel(
      senderId: senderId,
      receiverId: receiverId,
      sentAt: sentAt,
      senderImageUrl: senderImageUrl,
      senderName: senderName,
      requestId: requestId,
      requestStatus: RequestStatus.pending,
    );

    await firestore.collection("friendRequests").doc(requestId).set(request.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyRequests() async {
    final requests =
        firestore.collection("friendRequests").where("receiverId", isEqualTo: firebaseAuth.currentUser!.uid).get();
    return requests;
  }
}
