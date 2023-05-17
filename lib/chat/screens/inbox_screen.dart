import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/widgets/search_bar.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/provider/inbox_provider.dart';
import 'package:social_app/chat/screens/conversation_screen.dart';
import 'package:social_app/common/widgets/header.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        child: ChangeNotifierProvider<InboxProvider>(
          create: (context) => InboxProvider(),
          child: Builder(builder: (context) {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Header(
                        screenTitle: "Inbox",
                        endIcon: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (context) {
                                    return const SelectFriend();
                                  });
                            },
                            icon: const Icon(Icons.add)),
                      ),
                      const SearchBar(),
                    ],
                  ),
                ),
                context.watch<InboxProvider>().myInboxUsers.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                              child: Text("Start a chat first"),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: context.watch<InboxProvider>().myInboxUsers.length,
                            itemBuilder: (context, index) {
                              final userIndex = context.watch<InboxProvider>().myInboxUsers[index];
                              return GestureDetector(
                                onTap: () {
                                  // print("go to user's chat scree");
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConversationScreen(
                                            user: userIndex.inboxUser,
                                            inboxUserModel: userIndex,
                                          )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          maxRadius: 25,
                                          backgroundImage: NetworkImage(userIndex.inboxUser.userProfileUrl!),
                                        ),
                                        title: Text(userIndex.inboxUser.userName),
                                        subtitle: Text(
                                          userIndex.lastMessage.messageText.length > 10
                                              ? '${userIndex.lastMessage.messageText.substring(0, 13)}...'
                                              : userIndex.lastMessage.messageText,
                                        ),
                                        trailing: Text(timeago.format(userIndex.lastMessage.sentAt)),
                                      )),
                                ),
                              );
                            }),
                      )
              ],
            );
          }),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                              user: InboxUser(
                                  userId: frndIndex.userUid,
                                  userName: frndIndex.userName,
                                  userProfileUrl: frndIndex.profilePicture),
                            )));
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
