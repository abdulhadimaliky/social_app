import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/user_profile_screen.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';
import 'package:social_app/dashboard/widgets/add_post.dart';
import 'package:social_app/dashboard/widgets/search_navbar.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    context.read<DashboardProvider>().getCurrentUserData();
    super.initState();
  }

  int bottomNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeTab(),
      const Center(child: Text("notifications")),
      AddPost(user: context.watch<DashboardProvider>().currentUserData!),
      const SearchNavBar(),
      MyProfileScreen(user: context.watch<DashboardProvider>().currentUserData!),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            screens[bottomNavBarIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavBarIndex,
          onTap: (index) => setState(() {
            bottomNavBarIndex = index;
          }),
          selectedIconTheme: const IconThemeData(color: Colors.amber),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.notifications, color: Colors.black), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.black), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black), label: ""),
          ],
        ),
      ),
    );
  }
}

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  UserModel user;

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
                backgroundImage: NetworkImage(user.profilePicture!),
              ),
              title: Text(user.userName),
              subtitle: Text("@${user.userName}"),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.595,
              child: TabBarView(children: [
                const Center(child: Text("Hi")),
                DetailsTab(user: user),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Color(0xffFFFFFF),
        ),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Header(screenTitle: "People"),
                  ElevatedButton(
                      onPressed: () async {
                        await context.read<AuthProvider>().signout();
                        Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(builder: (context) => const OnboardingScreen()));
                      },
                      child: const Text("Log Out"))
                ],
              ),
              const SearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}
