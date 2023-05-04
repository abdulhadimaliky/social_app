import 'package:flutter/material.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/dashboard/repo/dashboard_repo.dart';

class DashboardProvider extends ChangeNotifier {
  UserModel? currentUserData;

  List<UserModel>? recommendations = [];

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
  ) async {
    await DashboardRepo().submitPost(
      postComments,
      postDescription,
      postLikes,
      postTitle,
    );
  }
}
