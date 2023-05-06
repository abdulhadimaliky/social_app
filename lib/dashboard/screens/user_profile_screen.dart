import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/widgets/post_card.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    context.read<DashboardProvider>().getUserPostsFromDB(widget.user.userUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const Header(screenTitle: "Profile"),
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.user.profilePicture!),
                ),
                title: Text(widget.user.userName),
                subtitle: Text("@${widget.user.userName}"),
                trailing: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blue),
                    child: TextButton(
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    )),
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
              Expanded(
                child: TabBarView(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...context.watch<DashboardProvider>().usersPosts!.map((e) => PostCard(
                                post: e,
                                onLiked: (post) {
                                  //TODO: TODO IMplement for user post.
                                  // context.read<DashboardProvider>().
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                  DetailsTab(user: widget.user),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsTab extends StatelessWidget {
  const DetailsTab({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Text(user.description),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset("assets/Image.png"),
                  title: Text(user.jobDetails),
                  subtitle: Text(user.profession),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${user.years} - present"),
                      const SizedBox(),
                    ],
                  ),
                ),
                Image.asset("assets/Pagination1.png")
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      indent: 10,
      endIndent: 10,
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }
}
