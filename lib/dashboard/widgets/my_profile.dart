import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/user_profile_screen.dart';
import 'package:social_app/dashboard/widgets/post_card.dart';

class MyProfile extends StatefulWidget {
  MyProfile({
    required this.user,
    Key? key,
  }) : super(key: key);

  UserModel user;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    context.read<DashboardProvider>().getMyPostsFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Header(screenTitle: "Profile"),
                IconButton(
                    onPressed: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //           backgroundColor: Colors.white,
                      //           contentPadding: const EdgeInsets.symmetric(horizontal: 200, vertical: 200),
                      //           title: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                      //           content: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               ListTile(
                      //                 leading: CircleAvatar(
                      //                   radius: 40,
                      //                   backgroundImage: NetworkImage(user.profilePicture!),
                      //                 ),
                      //                 title: Text(user.userName),
                      //                 subtitle: Text("@${user.userName}"),
                      //               ),
                      //             ],
                      //           ),
                      //         ));
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.user.profilePicture!),
              ),
              title: Text(widget.user.userName),
              subtitle: Text("@${widget.user.userName}"),
              trailing: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.user.connections.toString()),
                      const Text("Connections"),
                    ],
                  ),
                  const MyDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.user.followers.toString()),
                      const Text("Followers"),
                    ],
                  ),
                  const MyDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.user.connections.toString()),
                      const Text("Posts created"),
                    ],
                  ),
                ],
              ),
            ),
            const TabBar(
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              labelStyle: TextStyle(color: Colors.black),
              tabs: [
                Tab(
                  child: Text("Post"),
                ),
                Tab(
                  child: Text(
                    "Details",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.595,
              child: TabBarView(children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ...context.watch<DashboardProvider>().myPosts.map((post) => PostCard(
                            post: post,
                            onLiked: (post) {
                              context.read<DashboardProvider>().likeMyPost(post, post.postUserId);
                            },
                          ))
                    ],
                  ),
                ),
                DetailsTab(user: widget.user),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
