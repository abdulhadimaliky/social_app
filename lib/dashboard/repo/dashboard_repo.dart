import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/common/services/id_service.dart';
import 'package:social_app/dashboard/models/comment_model.dart';
import 'package:social_app/dashboard/models/friend_request_model.dart';
import 'package:social_app/dashboard/models/post_metadata.dart';
import 'package:social_app/dashboard/models/post_model.dart';

class DashboardRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostMetaData(String postId) async {
    final postMetaData = await firestore.collection("postMetaData").doc(postId).get();
    return postMetaData;
  }

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
    if (file != null) {
      final task = await firebaseStorage.ref("postImageUrl/${file.name}").putFile(File(file.path));
      final url = await task.ref.getDownloadURL();

      return url;
    }
    return null;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
  //   final receivedUser = await firestore.collection("userData").doc(id).get();
  //   return receivedUser;
  // }

  Future<void> submitPost(
    String postDescription,
    String postTitle,
    String posterUserId,
    String posterImageUrl,
    String posterName,
    XFile? file,
  ) async {
    final myPostId = IdService.generateId();
    final post = PostModel(
      postDescription: postDescription,
      postId: myPostId,
      postTitle: postTitle,
      postUserId: posterUserId,
      posterImageUrl: posterImageUrl,
      posterName: posterName,
      createdAt: DateTime.now(),
      postImageUrl: await uploadPostImage(file),
    );
    final postMetaData = PostMetaData(postCommentsCount: 0, postLikesCount: [], postId: myPostId);
    await firestore.collection("postMetaData").doc(myPostId).set(postMetaData.toJson());
    await firestore.collection("posts").doc(myPostId).set(post.toJson());
    await firestore.collection("userData").doc(posterUserId).collection("posts").doc(myPostId).set(post.toJson());
    final friendsId = await getMyFriendsId();
    for (final friendId in friendsId) {
      firestore.collection("userData").doc(friendId).collection("posts").doc(myPostId).set(post.toJson());
    }
  }

  Future<void> deletePost(String postId) async {
    await firestore.collection("posts").doc(postId).delete();
    await firestore.collection("userData").doc(firebaseAuth.currentUser!.uid).collection("posts").doc(postId).delete();
    final friendsId = await getMyFriendsId();
    for (final friendId in friendsId) {
      firestore.collection("userData").doc(friendId).collection("posts").doc(postId).delete();
    }
    await firestore.collection("postMetaData").doc(postId).delete();
  }

  Future<List<String>> getMyFriendsId() async {
    final snapshot =
        await firestore.collection("userData").doc(firebaseAuth.currentUser!.uid).collection("friends").get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMyPostsFromDB() async {
    final getMyPosts = await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("posts")
        .where("postUserId", isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .get();

    return getMyPosts;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPosts() async {
    final getAllPosts = await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .get();
    return getAllPosts;
  }

  Future<void> likePost(String postId, String userId) async {
    await firestore.collection("postMetaData").doc(postId).update({
      "postLikeCounts": FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unlikePost(PostMetaData post, String postId, String userId) async {
    await firestore.collection("postMetaData").doc(postId).update({
      "postLikeCounts": FieldValue.arrayRemove([userId])
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
    await firestore.collection("Posts").doc(postId).collection("comments").add(
          Comment(
            commentAt: DateTime.now(),
            text: commentBody,
            commenterImageUrl: commenterImageUrl,
            commenterName: commenterName,
          ).toJson(),
        );
    await firestore.collection("postMetaData").doc(postId).update({"postCommentsCount": FieldValue.increment(1)});
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
    final requests = firestore
        .collection("friendRequests")
        .where("receiverId", isEqualTo: firebaseAuth.currentUser!.uid)
        .where("requestStatus", isEqualTo: "pending")
        .get();
    return requests;
  }

  Future<void> acceptRequest(
    String senderId,
    UserModel? currentUser,
    String requestId,
  ) async {
    final senderDoc = await firestore.collection("userData").doc(senderId).get();

    await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("friends")
        .doc(senderId)
        .set(senderDoc.data()!);
    await firestore
        .collection("userData")
        .doc(senderId)
        .collection("friends")
        .doc(firebaseAuth.currentUser!.uid)
        .set(currentUser!.toJson());

    await firestore.collection("friendRequests").doc(requestId).update({"requestStatus": "accepted"});
  }
}


// ListView.builder(
              //     itemCount: context.watch<DashboardProvider>().allPosts.length,
              //     itemBuilder: (context, int index) {
              //       return Column(
              //         children: [
              //           ...context.watch<DashboardProvider>().allPosts.map((e) => PostCard(
              //                 post: e,
              //                 onLiked: (post) async {
              //                   await context
              //                       .read<DashboardProvider>()
              //                       .likePost(context.read<DashboardProvider>().postMetaData!, e.postId);
              //                 },
              //               ))
              //         ],
              //       );
              //     })