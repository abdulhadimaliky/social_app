import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/model/message_model.dart';
import 'package:social_app/chat/repo/chat_repo.dart';

class ChatProvider extends ChangeNotifier {
  final chatRepo = ChatRepo();

  List<InboxUserModel> myInboxUsers = [];
  List<MessageModel> userChatMessages = [];

  // StreamSubscription? _inboxSubscription;
  // StreamSubscription? _chatSubscription;

  Future<void> sentMessage(
    String receiverId,
    String messageText,
    String otherUserId,
    InboxUser myUser,
    InboxUser otherUser,
    DateTime lastOpenedByUserAt,
  ) async {
    await chatRepo.startChatTest(
      receiverId,
      messageText,
      otherUserId,
      myUser,
      otherUser,
      lastOpenedByUserAt,
    );
  }

  void openInboxUsersStream() {
    // _inboxSubscription =
    chatRepo.openInboxUsersStream().listen((event) {
      myInboxUsers = [...event];
      notifyListeners();
    });
  }

  void openUserChatStream(String otherUserId) {
    // _chatSubscription =
    chatRepo.openChatStream(otherUserId).listen((event) {
      userChatMessages = [...event];

      notifyListeners();
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _chatSubscription?.cancel();
  //   _inboxSubscription?.cancel();
  // }

  // Future<void> userInbox(
  //   String otherUserId,
  //   InboxUser myUser,
  //   InboxUser otherUser,
  //   MessageModel lastMessage,
  //   DateTime lastOpenedByUserAt,
  // ) async {
  //   await chatRepo.inboxUser(
  //     otherUserId,
  //     myUser,
  //     otherUser,
  //     lastMessage,
  //     lastOpenedByUserAt,
  //   );
  // }
}
