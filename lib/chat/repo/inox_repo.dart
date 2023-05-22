import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';

class InboxRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<InboxUserModel>> openInboxUsersStream() {
    return firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .orderBy("lastUpdatedAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => InboxUserModel.fromJson(e.data())).toList());
  }

  Future<void> updateInboxUser(String userId) async {
    firestore
        .collection("userData")
        .doc(userId)
        .collection("inbox")
        .doc("${userId}_${firebaseAuth.currentUser!.uid}")
        .update({"lastOpenedByUserAt": DateTime.now()});
  }
}
