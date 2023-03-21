import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/widgets/image_avatar.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text("Edit Profile"),
                    const SizedBox(width: 50)
                  ],
                ),
                Center(
                  child: UserProfilePicture(file: Provider.of<AuthProvider>(context).file),
                ),
                SignupTitleAndTextField(
                  title: "Your Full Name",
                  hintText: "Marina Kovalinko",
                  validate: (value) {},
                  controller: nameController,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
