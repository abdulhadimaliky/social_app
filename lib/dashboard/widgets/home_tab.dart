import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/widgets/post_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    context.read<DashboardProvider>().getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [...context.watch<DashboardProvider>().allPosts.map((e) => PostCard(post: e))],
            ),
          ),
        ),
      ],
    );
  }
}
