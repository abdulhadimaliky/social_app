import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/screens/user_profile_screen.dart';
import 'package:social_app/auth/widgets/add_button.dart';

class SearchNavBar extends StatefulWidget {
  const SearchNavBar({super.key});

  @override
  State<SearchNavBar> createState() => _SearchNavBarState();
}

class _SearchNavBarState extends State<SearchNavBar> {
  @override
  void initState() {
    context.read<AuthProvider>().getRecommendations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.695,
        child: Column(
          children: [
            ...context.watch<AuthProvider>().recommendations!.map((e) => Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // await context.read<AuthProvider>().getUserById(e.userUid);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen(user: e)));
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
    );
  }
}
