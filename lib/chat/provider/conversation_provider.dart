import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/model/message_model.dart';
import 'package:social_app/chat/repo/conversation_repo.dart';

class ConversationProvider extends ChangeNotifier {
  final String otherUserId;
  StreamSubscription? _conversationStream;

  ConversationProvider({required this.otherUserId}) {
    openUserChatStream(otherUserId);
  }

  final conversationRepo = ConversationRepo();

  List<MessageModel> userChatMessages = [];

  void openUserChatStream(String otherUserId) {
    // _chatSubscription =
    _conversationStream = conversationRepo.openChatStream(otherUserId).listen((event) {
      userChatMessages = [...event];

      notifyListeners();
    });
  }

  Future<void> sentMessage(
    String receiverId,
    String messageText,
    String otherUserId,
    InboxUser myUser,
    InboxUser otherUser,
    DateTime lastOpenedByUserAt,
  ) async {
    await conversationRepo.startChat(
      receiverId,
      messageText,
      otherUserId,
      myUser,
      otherUser,
      lastOpenedByUserAt,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _conversationStream?.cancel();
  }
}
