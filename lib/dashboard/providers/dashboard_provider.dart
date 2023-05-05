import 'package:flutter/material.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/repo/dashboard_repo.dart';

class DashboardProvider extends ChangeNotifier {
  UserModel? currentUserData;

  List<UserModel>? recommendations = [];
  List<PostModel>? myPosts = [];
  List<PostModel> allPosts = [];

  Future<void> getRecommendations() async {
    recommendations!.clear();
    final recs = await DashboardRepo().getRecommendations();

    for (final doc in recs.docs) {
      recommendations!.add(UserModel.fromJson(doc.data()));
    }

    notifyListeners();
  }

  Future<void> getCurrentUserData() async {
    final snapshot = await DashboardRepo().getCurrentUserData();

    if (snapshot.exists) {
      currentUserData = UserModel.fromJson(snapshot.data()!);
      notifyListeners();
    }
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
    await DashboardRepo().submitPost(
      postComments,
      postDescription,
      postLikes,
      postTitle,
      currentUserData!.profilePicture!,
      userName,
    );
  }

  Future<void> getMyPostsFromDB() async {
    myPosts!.clear();
    final myPost = await DashboardRepo().getMyPostsFromDB();
    for (final doc in myPost.docs) {
      myPosts!.add(PostModel.fromJson(doc.data()));
    }
    notifyListeners();
  }

  Future<void> getAllPosts() async {
    allPosts.clear();
    final post = await DashboardRepo().getAllPosts();

    for (final doc in post.docs) {
      allPosts.add(PostModel.fromJson(doc.data()));
    }
    notifyListeners();
  }
}
