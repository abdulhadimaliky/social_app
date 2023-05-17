import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
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
        .doc("${firebaseAuth.currentUser!.uid}_$receiverId")
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());

    await firestore
        .collection("userData")
        .doc(receiverId)
        .collection("inbox")
        .doc("${receiverId}_${firebaseAuth.currentUser!.uid}")
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());
  }

  Future<void> startChatTest(
    String receiverId,
    String messageText,
    String otherUserId,
    InboxUser myUser,
    InboxUser otherUser,
    DateTime lastOpenedByUserAt,
  ) async {
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
        .doc("${firebaseAuth.currentUser!.uid}_$receiverId")
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());

    await firestore
        .collection("userData")
        .doc(receiverId)
        .collection("inbox")
        .doc("${receiverId}_${firebaseAuth.currentUser!.uid}")
        .collection("messages")
        .doc(messageId)
        .set(message.toJson());

    final myInboxId = "${firebaseAuth.currentUser!.uid}_$otherUserId";
    final otherUserInboxId = "${otherUserId}_${firebaseAuth.currentUser!.uid}";
    final myUserData = InboxUserModel(
        inboxId: myInboxId,
        inboxUser: otherUser,
        lastMessage: message,
        lastOpenedByUserAt: lastOpenedByUserAt,
        lastUpdatedAt: message.sentAt);

    await firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .doc("${firebaseAuth.currentUser!.uid}_$otherUserId")
        .set(myUserData.toJson());

    final otherUserData = InboxUserModel(
        inboxId: myInboxId,
        inboxUser: myUser,
        lastMessage: message,
        lastOpenedByUserAt: lastOpenedByUserAt,
        lastUpdatedAt: message.sentAt);

    await firestore
        .collection("userData")
        .doc(otherUserId)
        .collection("inbox")
        .doc(otherUserInboxId)
        .set(otherUserData.toJson());
  }

  // Future<void> inboxUser(String otherUserId, InboxUser myUser, InboxUser otherUser, MessageModel lastMessage,
  //     DateTime lastOpenedByUserAt) async {
  //   final myInboxId = "${firebaseAuth.currentUser!.uid}_$otherUserId";
  //   final otherUserInboxId = "${otherUserId}_${firebaseAuth.currentUser!.uid}";
  //   final myUserData = InboxUserModel(
  //       inboxId: myInboxId,
  //       inboxUser: otherUser,
  //       lastMessage: lastMessage,
  //       lastOpenedByUserAt: lastOpenedByUserAt,
  //       lastUpdatedAt: lastMessage.sentAt);

  //   await firestore
  //       .collection("userData")
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .collection("inbox")
  //       .doc("${firebaseAuth.currentUser!.uid}_$otherUserId")
  //       .set(myUserData.toJson());

  //   final otherUserData = InboxUserModel(
  //       inboxId: myInboxId,
  //       inboxUser: myUser,
  //       lastMessage: lastMessage,
  //       lastOpenedByUserAt: lastOpenedByUserAt,
  //       lastUpdatedAt: lastMessage.sentAt);

  //   await firestore
  //       .collection("userData")
  //       .doc(otherUserId)
  //       .collection("inbox")
  //       .doc(otherUserInboxId)
  //       .set(otherUserData.toJson());
  // }

  Stream<List<InboxUserModel>> openInboxUsersStream() {
    return firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .orderBy("lastUpdatedAt", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => InboxUserModel.fromJson(e.data())).toList());
  }

  Stream<List<MessageModel>> openChatStream(String otherUserId) {
    return firestore
        .collection("userData")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("inbox")
        .doc("${firebaseAuth.currentUser!.uid}_$otherUserId")
        .collection("messages")
        .orderBy("sentAt", descending: false)
        .snapshots()
        .map((event) => event.docs.map((e) => MessageModel.fromJson(e.data())).toList());
  }

  // Future<InboxUser> getInboxUser(String userId) async {
  //   final user = firestore
  //       .collection("userData")
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .collection("inbox")
  //       .doc("${firebaseAuth.currentUser!.uid}_$userId").;

  // }
}
