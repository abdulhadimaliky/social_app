import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  XFile? file;

  UserModel? user;

  final authRep = AuthRepo();

  Future<void> signinWithGoogle() async {
    await authRep.signInWithGoogle();
  }

  Future<void> signin(String email, String password) async {
    await authRep.signin(email, password);
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await authRep.createUser(email, password);
  }

  void setUserImageFile(XFile sentFile) {
    file = sentFile;
    notifyListeners();
  }

  Future<String?> uploadDP() async {
    final url = await authRep.uploadUserProfileImage(file);
    return url;
  }

  Future<void> submitForm(
      {required String description,
      required String jobDetails,
      required String location,
      required String profession,
      required String userName,
      required String years}) async {
    await authRep.submitForm(
      await uploadDP(),
      description,
      jobDetails,
      location,
      profession,
      userName,
      years,
    );
  }

  Future<UserModel?> checkUserInDB() async {
    final snapshot = await authRep.checkUserInDB();
    if (snapshot.exists) {
      user = UserModel.fromJson(snapshot.data()!);
      return user;
    }

    notifyListeners();
    return null;
  }

  Future<void> checkUserById(String userId) async {
    await authRep.checkUserById(userId);
  }

  Future<void> signout() async {
    await authRep.signout();
  }
}
