import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/widgets/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key, required this.user});
  UserModel user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
            backgroundColor: Colors.grey.shade50,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    maxRadius: 25,
                    backgroundImage: NetworkImage(user.profilePicture!),
                  ),
                  title: Text(user.userName),
                  subtitle: Text("@${user.userName}"),
                ),
                const Divider(thickness: 1.5),
                Column(
                  children: [
                    SettingItem(
                      icon: Icons.person,
                      itemTitle: "Your Profile",
                      color: const Color(0xff007AFF).withOpacity(0.1),
                      iconColor: const Color(0xff007AFF),
                    ),
                    SettingItem(
                      icon: Icons.notifications,
                      itemTitle: "Network",
                      color: const Color(0xff1DD1A1).withOpacity(0.1),
                      iconColor: const Color(0xff1DD1A1),
                    ),
                    SettingItem(
                      icon: Icons.group,
                      itemTitle: "Forum",
                      color: const Color(0xffFFDC2B).withOpacity(0.1),
                      iconColor: const Color(0xffFFDC2B),
                    ),
                    SettingItem(
                      icon: Icons.edit,
                      itemTitle: "Edit Profile",
                      color: const Color(0xffCB64FF).withOpacity(0.1),
                      iconColor: const Color(0xffCB64FF),
                    ),
                    SettingItem(
                      icon: Icons.search,
                      itemTitle: "Search",
                      color: const Color(0xffFF375F).withOpacity(0.1),
                      iconColor: const Color(0xffFF375F),
                    ),
                  ],
                ),
                const Divider(thickness: 1.5),
                Column(
                  children: [
                    SettingItem(
                      icon: Icons.settings,
                      itemTitle: "Settings",
                      color: const Color(0xff007AFF).withOpacity(0.1),
                      iconColor: const Color(0xff007AFF),
                    ),
                    SettingItem(
                      icon: Icons.priority_high,
                      itemTitle: "About Us",
                      color: const Color(0xff5AC8FA).withOpacity(0.1),
                      iconColor: const Color(0xff5AC8FA),
                    ),
                    SettingItem(
                      icon: Icons.translate,
                      itemTitle: "Language",
                      color: const Color(0xffFFA92F).withOpacity(0.1),
                      iconColor: const Color(0xffFFA92F),
                    ),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await context.read<AuthProvider>().signout();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ));
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffFF375F),
                          ),
                          child: const Icon(Icons.logout, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        const Text("Log OUt")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
