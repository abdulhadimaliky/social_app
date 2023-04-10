import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/widgets/add_button.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    context.read<AuthProvider>().getRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.678,
                child: Column(
                  children: [
                    ...context.watch<AuthProvider>().recommendations!.map((e) => Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e.profilePicture!),
                              ),
                              title: Text(e.userName),
                              subtitle: Text(e.profession),
                              trailing: const AddButton(),
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
            BottomNavigationBar(items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.notifications, color: Colors.black), label: ""),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      )),
                  label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle, color: Colors.black), label: ""),
            ])
          ],
        ),
      ),
    );
  }
}
