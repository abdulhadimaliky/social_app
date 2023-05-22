import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/provider/conversation_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationScreen extends StatelessWidget {
  ConversationScreen({
    super.key,
    required this.user,
    this.inboxUserModel,
  });

  final InboxUser user;
  final InboxUserModel? inboxUserModel;

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConversationProvider>(
      create: (context) => ConversationProvider(otherUserId: user.userId),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                child: CircleAvatar(
                                  minRadius: 25,
                                  backgroundImage: NetworkImage(user.userProfileUrl!),
                                ),
                              ),
                              const Positioned(
                                  bottom: 15,
                                  right: 5,
                                  child: CircleAvatar(
                                    maxRadius: 7.5,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      maxRadius: 6,
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user.userName,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Builder(builder: (context) {
                            final userChatMessages = context.watch<ConversationProvider>().userChatMessages;

                            if (userChatMessages.isEmpty) {
                              return const Center(child: Text("Start Messaging"));
                            }
                            return ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                addAutomaticKeepAlives: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: userChatMessages.length,
                                itemBuilder: (context, index) {
                                  final messageIndex = userChatMessages[index];
                                  return Builder(builder: (context) {
                                    print("I AM BUILT");
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: messageIndex.senderId == user.userId
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        messageIndex.senderId == user.userId
                                            ? CircleAvatar(backgroundImage: NetworkImage(user.userProfileUrl!))
                                            : const SizedBox(),
                                        Column(
                                          crossAxisAlignment: messageIndex.senderId == user.userId
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: messageIndex.messageText.length > 20
                                                  ? MediaQuery.of(context).size.width * 0.65
                                                  : null,
                                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: Text(
                                                  messageIndex.messageText,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // inboxUserModel!.lastMessage.senderId ==
                                                //         context.read<DashboardProvider>().currentUserData!.userUid
                                                //     ? const Icon(Icons.check)
                                                //     : const SizedBox(),
                                                if (messageIndex.messageId == userChatMessages.first.messageId &&
                                                    userChatMessages.first.senderId ==
                                                        context.read<DashboardProvider>().currentUserData!.userUid)
                                                  Icon(Icons.check,
                                                      color: inboxUserModel!.lastOpenedByUserAt
                                                              .isAfter(inboxUserModel!.lastMessage.sentAt)
                                                          ? Colors.green
                                                          : Colors.grey)
                                                else
                                                  const SizedBox(),
                                                Text(timeago.format(messageIndex.sentAt)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        messageIndex.senderId ==
                                                context.read<DashboardProvider>().currentUserData!.userUid
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    context.read<DashboardProvider>().currentUserData!.profilePicture!))
                                            : const SizedBox(),
                                      ],
                                    );
                                  });
                                });
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Icon(Icons.attach_file, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: const TextStyle(color: Colors.grey),
                            constraints: const BoxConstraints(maxHeight: 60),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            context.read<ConversationProvider>().sentMessage(
                                  user.userId,
                                  messageController.text,
                                  user.userId,
                                  InboxUser(
                                    userName: context.read<DashboardProvider>().currentUserData!.userName,
                                    userProfileUrl: context.read<DashboardProvider>().currentUserData!.profilePicture!,
                                    userId: context.read<DashboardProvider>().currentUserData!.userUid,
                                  ),
                                  InboxUser(
                                    userName: user.userName,
                                    userProfileUrl: user.userProfileUrl,
                                    userId: user.userId,
                                  ),
                                  DateTime.now(),
                                  myInboxUserModel: inboxUserModel,
                                );
                            messageController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          )),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
