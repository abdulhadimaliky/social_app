import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/common/services/id_service.dart';
import 'package:social_app/dashboard/models/comment_model.dart';
import 'package:social_app/dashboard/models/friend_request_model.dart';
import 'package:social_app/dashboard/models/post_metadata.dart';
import 'package:social_app/dashboard/models/post_model.dart';

class DashboardRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  Future<List<InboxUserModel>> getUnreadMessagesCount() async {
    final userInboxCount = await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .where("unreadMessagesCount", isEqualTo: 1)
        .get();

    final count = userInboxCount.docs.map((e) => InboxUserModel.fromJson(e.data())).toList();
    return count;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostMetaData(String postId) async {
    final postMetaData = await firestore.collection("postMetaData").doc(postId).get();
    return postMetaData;
  }

  Future<List<UserModel>> getMyFriends() async {
    // final myFriendsId = await getMyFriendsId();
    final frnd = await firestore.collection("userData").get();
    final user = frnd.docs.map((e) => UserModel.fromJson(e.data())).toList();
    user.removeWhere((element) => element.userUid == firebaseAuth.currentUser!.uid);
    // print(frnds);
    return user;
  }

  Future<List<UserModel>> getRecommendations() async {
    final myfriends = await getMyFriendsId();
    final getRecs = await firestore.collection("userData").get();
    final users = getRecs.docs.map((e) => UserModel.fromJson(e.data())).toList();
    users.removeWhere(
        (element) => myfriends.contains(element.userUid) || element.userUid == firebaseAuth.currentUser?.uid);

    return users;
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

  Future<List<PostModel>> getAllPosts() async {
    final getAllPosts = await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .get();

    return getAllPosts.docs.map((e) => PostModel.fromJson(e.data())).toList();
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
        .collection("userData")
        .doc(posterId)
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .get();

    return getMyPosts;
  }

  Future<void> addComment(String postId, String commentBody, String commenterImageUrl, String commenterName) async {
    await firestore.collection("posts").doc(postId).collection("comments").add(
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
        .collection("posts")
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
