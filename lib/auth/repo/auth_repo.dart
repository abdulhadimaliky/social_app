import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  XFile? file;

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

  Future<String?> uploadUserProfileImage() async {
    if (file != null) {
      final task = await firebaseStorage.ref("users/${file!.name}").putFile(File(file!.path));

      return await task.ref.getDownloadURL();
    }
  }
}
