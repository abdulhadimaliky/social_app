import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/dashboard/models/comment_model.dart';
import 'package:social_app/dashboard/models/friend_request_model.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/repo/dashboard_repo.dart';

class DashboardProvider extends ChangeNotifier {
  UserModel? currentUserData;

  XFile? file;

  final dashboardRepo = DashboardRepo();

  List<UserModel> recommendations = [];
  List<PostModel> myPosts = [];
  List<PostModel> allPosts = [];
  List<PostModel> usersPosts = [];
  List<Comment> comments = [];
  List<FriendRequestModel> myFriendRequests = [];

  Future<void> sendFriendRequest(
    String receiverId,
  ) async {
    await dashboardRepo.sendRequest(currentUserData!.userUid, receiverId, DateTime.now(),
        currentUserData!.profilePicture!, currentUserData!.userName);
  }

  Future<void> getMyRequests() async {
    myFriendRequests.clear();
    final myRequests = await dashboardRepo.getMyRequests();

    for (final request in myRequests.docs) {
      myFriendRequests.add(FriendRequestModel.fromJson(request.data()));
      notifyListeners();
    }
  }

  Future<void> getRecommendations() async {
    recommendations.clear();
    final recs = await dashboardRepo.getRecommendations();

    for (final doc in recs.docs) {
      recommendations.add(UserModel.fromJson(doc.data()));
    }

    notifyListeners();
  }

  Future<void> getCurrentUserData() async {
    final snapshot = await dashboardRepo.getCurrentUserData();

    if (snapshot.exists) {
      currentUserData = UserModel.fromJson(snapshot.data()!);
      notifyListeners();
    }
  }

  void setPostImageFile(XFile sentFile) {
    file = sentFile;
    notifyListeners();
  }

  Future<String?> uploadPostImage() async {
    final url = await dashboardRepo.uploadPostImage(file);
    return url;
  }
  // Future<void> getUserById(String id) async {
  //   final receivedUser = await AuthRepo().getUserById(id);
  //   UserModel.fromJson(receivedUser.data()!);
  // }

  Future<void> submitPost(
    int postComments,
    String postDescription,
    int postLikes,
    String postTitle,
    String userName,
  ) async {
    log("FILE: $file");
    await dashboardRepo.submitPost(
      postComments,
      postDescription,
      [],
      postTitle,
      currentUserData!.profilePicture!,
      userName,
      file,
    );
  }

  Future<void> getMyPostsFromDB() async {
    myPosts.clear();
    final myPost = await dashboardRepo.getMyPostsFromDB();
    for (final doc in myPost.docs) {
      myPosts.add(PostModel.fromJson(doc.data()));
    }
    notifyListeners();
  }

  Future<void> getAllPosts() async {
    allPosts.clear();
    final post = await dashboardRepo.getAllPosts();

    for (final doc in post.docs) {
      allPosts.add(PostModel.fromJson(doc.data()));
    }
    notifyListeners();
  }

  Future<void> likePost(PostModel selectedPost, String userId) async {
    final indexOfPost = allPosts.indexWhere((element) => element.postId == selectedPost.postId);
    if (selectedPost.likedBy.contains(userId)) {
      await dashboardRepo.unlikePost(selectedPost, userId);
      allPosts[indexOfPost].likedBy.removeWhere((element) => element == userId);
    } else {
      await dashboardRepo.likePost(selectedPost, userId);
      allPosts[indexOfPost].likedBy.add(userId);
    }
    notifyListeners();
  }

  Future<void> likeMyPost(PostModel selectedPost, String userId) async {
    final indexOfPost = myPosts.indexWhere((element) => element.postId == selectedPost.postId);
    if (selectedPost.likedBy.contains(userId)) {
      await dashboardRepo.unlikePost(selectedPost, userId);
      myPosts[indexOfPost].likedBy.removeWhere((element) => element == userId);
    } else {
      await dashboardRepo.likePost(selectedPost, userId);
      myPosts[indexOfPost].likedBy.add(userId);
    }
    notifyListeners();
  }

  Future<void> likeUserPost(PostModel selectedPost, String userId) async {
    final indexOfPost = usersPosts.indexWhere((element) => element.postId == selectedPost.postId);
    if (selectedPost.likedBy.contains(userId)) {
      await dashboardRepo.unlikePost(selectedPost, userId);
      usersPosts[indexOfPost].likedBy.removeWhere((element) => element == userId);
    } else {
      await dashboardRepo.likePost(selectedPost, userId);
      usersPosts[indexOfPost].likedBy.add(userId);
    }
    notifyListeners();
  }

  Future<void> getUserPostsFromDB(String userId) async {
    usersPosts.clear();
    final usersPost = await dashboardRepo.getUserPostsFromDB(userId);
    for (final doc in usersPost.docs) {
      usersPosts.add(PostModel.fromJson(doc.data()));
    }
    notifyListeners();
  }

  Future<void> addComment(String postId, String commentBody, String text) async {
    await dashboardRepo.addComment(postId, commentBody, currentUserData!.profilePicture!, currentUserData!.userName);
    final indexOfPost = allPosts.indexWhere((element) => element.postId == postId);
    if (text == "home") {
      final indexOfPost = allPosts.indexWhere((element) => element.postId == postId);
      allPosts[indexOfPost].postComments++;
    } else if (text == "mypost") {
      final indexOfPost = myPosts.indexWhere((element) => element.postId == postId);
      myPosts[indexOfPost].postComments++;
    } else if (text == "user") {
      final indexOfPost = usersPosts.indexWhere((element) => element.postId == postId);
      usersPosts[indexOfPost].postComments++;
    }

    notifyListeners();
  }

  void openCommentsStream(String postId) {
    dashboardRepo.openCommentsStream(postId).listen((event) {
      comments = [...event];
      notifyListeners();
    });
  }
}
