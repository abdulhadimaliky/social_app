import 'package:flutter/material.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/widgets/header.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              const Header(screenTitle: "Profile"),
              ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.profilePicture!),
                ),
                title: Text(user.userName),
                subtitle: Text("@${user.userName}"),
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
                        Text(user.connections.toString()),
                        const Text("Connections"),
                      ],
                    ),
                    const MyDivider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.followers.toString()),
                        const Text("Followers"),
                      ],
                    ),
                    const MyDivider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.connections.toString()),
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
              const Expanded(
                child: TabBarView(children: [
                  Center(child: Text("Hi")),
                  Center(child: Text("Hello")),
                ]),
              )
            ],
          ),
        ),
      ),
    );
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
