import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';
import 'package:social_app/auth/widgets/search_navbar.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    context.read<AuthProvider>().getCurrentUserData();
    super.initState();
  }

  int bottomNavBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeTab(),
      const Center(child: Text("notifications")),
      const Center(child: Text("Add")),
      const SearchNavBar(),
      UserProfileScreen(user: context.watch<AuthProvider>().currentUserData!),
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

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  UserModel user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [Text(user.userName)],
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
