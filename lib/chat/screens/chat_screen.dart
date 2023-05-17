import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/chat/model/inbox_user_model.dart';
import 'package:social_app/chat/provider/chat_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.user,
    required this.provider,
    this.inboxUserModel,
  });

  final InboxUser user;
  final ChatProvider provider;
  final InboxUserModel? inboxUserModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatProvider>().openUserChatStream(widget.user.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>.value(
      value: widget.provider,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
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
                        CircleAvatar(
                          minRadius: 25,
                          backgroundImage: NetworkImage(widget.user.userProfileUrl!),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.user.userName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
                  ],
                ),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  final userChatMessages = context.watch<ChatProvider>().userChatMessages;

                  if (userChatMessages.isEmpty) {
                    return const Center(child: Text("Start Messaging"));
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: userChatMessages.length,
                      itemBuilder: (context, index) {
                        final messageIndex = userChatMessages[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: messageIndex.senderId == widget.user.userId
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            messageIndex.senderId == widget.user.userId
                                ? CircleAvatar(backgroundImage: NetworkImage(widget.user.userProfileUrl!))
                                : const SizedBox(),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: FittedBox(
                                  child: Text(
                                    messageIndex.messageText,
                                  ),
                                ),
                              ),
                            ),
                            messageIndex.senderId == context.read<DashboardProvider>().currentUserData!.userUid
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        context.read<DashboardProvider>().currentUserData!.profilePicture!))
                                : const SizedBox(),
                          ],
                        );
                      });
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            context.read<ChatProvider>().sentMessage(
                                  widget.user.userId,
                                  messageController.text,
                                  widget.user.userId,
                                  InboxUser(
                                    userName: context.read<DashboardProvider>().currentUserData!.userName,
                                    userProfileUrl: context.read<DashboardProvider>().currentUserData!.profilePicture!,
                                    userId: context.read<DashboardProvider>().currentUserData!.userUid,
                                  ),
                                  InboxUser(
                                    userName: widget.user.userName,
                                    userProfileUrl: widget.user.userProfileUrl,
                                    userId: widget.user.userId,
                                  ),
                                  DateTime.now(),
                                );
                            messageController.clear();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
