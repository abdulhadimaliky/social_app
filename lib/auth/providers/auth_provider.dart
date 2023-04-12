import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/repo/auth_repo.dart';
import 'package:social_app/auth/widgets/add_button.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  XFile? file;

  UserModel? user;

  List<UserModel>? recommendations = [];

  Future<void> signin(String email, String password) async {
    await AuthRepo().signin(email, password);
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await AuthRepo().createUser(email, password);
  }

  void setUserImageFile(XFile sentFile) {
    file = sentFile;
    notifyListeners();
  }

  Future<String?> uploadDP() async {
    final url = await AuthRepo().uploadUserProfileImage(file);
    return url;
  }

  Future<void> submitForm(
      {required String description,
      required String jobDetails,
      required String location,
      required String profession,
      required String userName,
      required String years}) async {
    await AuthRepo().submitForm(await uploadDP(), description, jobDetails, location, profession, userName, years);
  }

  Future<void> checkUserInDB() async {
    await AuthRepo().checkUserInDB();
    notifyListeners();
  }

  Future<void> signout() async {
    await AuthRepo().signout();
  }

  Future<void> getRecommendations() async {
    recommendations!.clear();
    final recs = await AuthRepo().getRecommendations();

    for (final doc in recs.docs) {
      recommendations!.add(UserModel.fromJson(doc.data()));
    }

    notifyListeners();
  }

  // Future<void> getUserById(String id) async {
  //   final receivedUser = await AuthRepo().getUserById(id);
  //   UserModel.fromJson(receivedUser.data()!);
  // }
}
