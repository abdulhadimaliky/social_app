import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> createUser(String email, String pass) async {
    return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
  }

  Future<void> signin(String email, String pass) async {
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
  }
}
