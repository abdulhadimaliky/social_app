import 'package:flutter/material.dart';
import 'package:social_app/auth/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                  Row(
                    children: [
                      CircleAvatar(
                        minRadius: 25,
                        backgroundImage: NetworkImage(widget.user.profilePicture!),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          // print(messageController.text);
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
    );
  }
}
