import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/user_profile_screen.dart';
import 'package:social_app/dashboard/widgets/add_button.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';

class SearchNavBar extends StatefulWidget {
  const SearchNavBar({super.key});

  @override
  State<SearchNavBar> createState() => _SearchNavBarState();
}

class _SearchNavBarState extends State<SearchNavBar> {
  @override
  void initState() {
    context.read<DashboardProvider>().getRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.695,
        child: Column(
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
            ...context.watch<DashboardProvider>().recommendations.map((e) => Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen(user: e)));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(e.profilePicture!),
                        ),
                        title: Text(e.userName),
                        subtitle: Text(e.profession),
                        trailing: AddButton(userId: e.userUid),
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
    );
  }
}
