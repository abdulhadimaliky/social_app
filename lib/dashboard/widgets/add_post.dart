import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';
import 'package:social_app/dashboard/widgets/post_picture.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.user});

  final UserModel user;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  void initState() {
    context.read<DashboardProvider>().getCurrentUserData();
    context.read<DashboardProvider>().file == null;
    super.initState();
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)),
                const Text("Create a Post"),
                TextButton(
                    onPressed: () async {
                      await context.read<DashboardProvider>().submitPost(
                            0,
                            descriptionController.text,
                            0,
                            titleController.text,
                            widget.user.userName,
                          );
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => const PeopleScreen()));
                      // The Post image should turn null after submitting a post,
                      //because when the user tries to post again, the post picture remains to be the image of the last post.
                    },
                    child: const Text("Post"))
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profilePicture!),
              ),
              title: Text(widget.user.userName),
              subtitle: Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  // color: Colors.black,
                ),
                child: const Center(child: Text("Public")),
              ),
              trailing: const SizedBox(width: 180),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Post Title",
                hintStyle: const TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              textAlignVertical: TextAlignVertical.top,
              // textAlign: TextAlign.end,
              // style: const TextStyle(height: 5),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "What do you want to talk about?",
                hintStyle: const TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            PostPicure(file: context.watch<DashboardProvider>().file)
          ],
        ),
      ),
    );
  }
}
