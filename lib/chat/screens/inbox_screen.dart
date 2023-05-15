import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chat/screens/chat_screen.dart';
import 'package:social_app/common/widgets/header.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              screenTitle: "Inbox",
              endIcon: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return const SelectFriend();
                        });
                  },
                  icon: const Icon(Icons.add)),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectFriend extends StatefulWidget {
  const SelectFriend({super.key});

  @override
  State<SelectFriend> createState() => _SelectFriendState();
}

class _SelectFriendState extends State<SelectFriend> {
  @override
  void initState() {
    context.read<DashboardProvider>().myFriendss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Select a friend to start chatting"),
        Expanded(
          child: ListView.builder(
              itemCount: context.watch<DashboardProvider>().myFriends.length,
              itemBuilder: (context, index) {
                print(context.watch<DashboardProvider>().myFriends.length);
                final frndIndex = context.watch<DashboardProvider>().myFriends[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(user: frndIndex)));
                  },
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(frndIndex.profilePicture!)),
                    title: Text(frndIndex.userName),
                  ),
                );
              }),
        )
      ],
    );
  }
}
