import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/repo/inox_repo.dart';

class InboxProvider extends ChangeNotifier {
  final inboxRepo = InboxRepo();

  InboxProvider() {
    openInboxUsersStream();
  }

  List<InboxUserModel> myInboxUsers = [];

  StreamSubscription? _inboxSubscription;

  void openInboxUsersStream() {
    _inboxSubscription = inboxRepo.openInboxUsersStream().listen((event) {
      myInboxUsers = [...event];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inboxSubscription?.cancel();
  }

  Future<void> updateInboxUser(String userId) async {
    inboxRepo.updateInboxUser(userId);
  }
}
