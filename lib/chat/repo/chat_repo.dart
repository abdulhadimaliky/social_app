import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/chat/model/message_model.dart';
import 'package:social_app/common/services/id_service.dart';

class ChatRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> startChat(String receiverId, String messageText) async {
    final messageId = IdService.generateId();
    final message = MessageModel(
        messageId: messageId,
        messageText: messageText,
        senderId: firebaseAuth.currentUser!.uid,
        sentAt: DateTime.now());

    await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .doc("${firebaseAuth.currentUser!.uid}$receiverId")
        .set(message.toJson());

    await firestore
        .collection("userData")
        .doc(receiverId)
        .collection("inbox")
        .doc("$receiverId${firebaseAuth.currentUser!.uid}")
        .set(message.toJson());
  }
}
