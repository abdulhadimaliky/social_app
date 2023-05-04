import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardRepo {
  final firebaseAuth = FirebaseAuth.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getRecommendations() async {
    final getRecs = await FirebaseFirestore.instance
        .collection("userData")
        .where("userUid", isNotEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    return getRecs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    final getRecs = await FirebaseFirestore.instance.collection("userData").doc(firebaseAuth.currentUser!.uid).get();

    return getRecs;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) async {
  //   final receivedUser = await firestore.collection("userData").doc(id).get();
  //   return receivedUser;
  // }
}
