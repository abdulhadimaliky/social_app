import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/auth/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  XFile? file;

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
}
