import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/providers/auth_provider.dart';

class AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UserModel? user;

  Future<UserCredential> createUser(String email, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signin(String email, String pass) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> uploadUserProfileImage(XFile? file) async {
    if (file != null) {
      final task = await firebaseStorage.ref("users/${file.name}").putFile(File(file.path));
      final url = await task.ref.getDownloadURL();
      return url;
    }
  }

  Future<void> submitForm(String? profilePicture, String description, String jobDetails, String location,
      String profession, String userName, String years) async {
    user = UserModel(
      profilePicture: profilePicture,
      description: description,
      jobDetails: jobDetails,
      location: location,
      profession: profession,
      userName: userName,
      userUid: firebaseAuth.currentUser!.uid,
      years: years,
    );

    await firestore.collection("userData").doc(FirebaseAuth.instance.currentUser!.uid).set(user!.toJson());
  }

  Future<void> checkUserInDB() async {
    final snapshot = await firestore.collection("userData").doc(firebaseAuth.currentUser!.uid).get();
    if (snapshot.exists) {
      user = UserModel.fromJson(snapshot.data()!);
    }
  }

  Future<void> signout() async {
    await firebaseAuth.signOut();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRecommendations() async {
    final getRecs = await FirebaseFirestore.instance
        .collection("userData")
        .where("userUid", isNotEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    return getRecs;
  }
}
