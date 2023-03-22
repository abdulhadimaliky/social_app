import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/widgets/image_avatar.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';
import 'package:social_app/auth/widgets/textfield_tags.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController jobYearsController = TextEditingController();
  final TextEditingController professionalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: SingleChildScrollView(
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
                    fieldSize: "full",
                    title: "Your Full Name",
                    hintText: "Marina Kovalinko",
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name";
                      }
                    },
                    controller: nameController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SignupTitleAndTextField(
                        title: "Profession",
                        hintText: "Doctor",
                        validate: (value) {},
                        controller: professionController,
                        fieldSize: "no",
                      ),
                      SignupTitleAndTextField(
                        title: "Location",
                        hintText: "Kiev, UA",
                        validate: (value) {},
                        controller: locationController,
                        fieldSize: "no",
                      ),
                    ],
                  ),
                  SignupTitleAndTextField(
                    title: "Description",
                    hintText: "Write Description",
                    validate: (value) {},
                    controller: descriptionController,
                    fieldSize: "full",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SignupTitleAndTextField(
                        title: "Job Details",
                        hintText: "Universum Clinic",
                        validate: (value) {},
                        controller: jobController,
                        fieldSize: "no",
                      ),
                      SignupTitleAndTextField(
                        title: "Years",
                        hintText: "2014 - present",
                        validate: (value) {},
                        controller: jobYearsController,
                        fieldSize: "no",
                      ),
                    ],
                  ),
                  const TextfieldTags(title: "Professional"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
