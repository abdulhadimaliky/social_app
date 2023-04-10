import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/screens/user_profile_screen.dart';
import 'package:social_app/auth/widgets/add_button.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  int bottomNavBarIndex = 0;
  @override
  void initState() {
    context.read<AuthProvider>().getRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const Center(child: Text("Home")),
      const Center(child: Text("notifications")),
      const Center(child: Text("Add")),
      SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.695,
          child: Column(
            children: [
              ...context.watch<AuthProvider>().recommendations!.map((e) => Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await context.read<AuthProvider>().getUserById(e.userUid);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => UserProfileScreen(userId: e)));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(e.profilePicture!),
                          ),
                          title: Text(e.userName),
                          subtitle: Text(e.profession),
                          trailing: const AddButton(),
                        ),
                      ),
                      const Divider(
                        height: 5,
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      const Center(child: Text("Profile")),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Container(
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
            screens[bottomNavBarIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNavBarIndex,
          onTap: (index) => setState(() {
            bottomNavBarIndex = index;
          }),
          // selectedItemColor: Colors.amber,
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
