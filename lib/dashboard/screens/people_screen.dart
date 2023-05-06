import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/widgets/add_post.dart';
import 'package:social_app/dashboard/widgets/home_tab.dart';
import 'package:social_app/dashboard/widgets/my_profile.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: context.watch<DashboardProvider>().currentUserData == null
            ? const CircularProgressIndicator()
            : [
                const HomeTab(),
                const Center(child: Text("notifications")),
                AddPost(user: context.watch<DashboardProvider>().currentUserData!),
                const SearchNavBar(),
                MyProfile(user: context.watch<DashboardProvider>().currentUserData!),
              ][bottomNavBarIndex],
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
