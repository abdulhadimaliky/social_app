import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/image_avatar.dart';
import 'package:social_app/auth/widgets/personal_field.dart';
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

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Header(screenTitle: "Edit Profile"),
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
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your profession";
                            }
                          },
                          controller: professionController,
                          fieldSize: "no",
                        ),
                        SignupTitleAndTextField(
                          title: "Location",
                          hintText: "Kiev, UA",
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your location";
                            }
                          },
                          controller: locationController,
                          fieldSize: "no",
                        ),
                      ],
                    ),
                    SignupTitleAndTextField(
                      title: "Description",
                      hintText: "Write Description",
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Enter your description";
                        }
                      },
                      controller: descriptionController,
                      fieldSize: "full",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SignupTitleAndTextField(
                          title: "Job Details",
                          hintText: "Universum Clinic",
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your job details";
                            }
                          },
                          controller: jobController,
                          fieldSize: "no",
                        ),
                        SignupTitleAndTextField(
                          title: "Years",
                          hintText: "2014 - present",
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your experience period";
                            }
                          },
                          controller: jobYearsController,
                          fieldSize: "no",
                        ),
                      ],
                    ),
                    const TextfieldTags(title: "Professional", initialList: [
                      'Work Experience',
                      'Niche',
                      'Target',
                      'Education',
                      'Products',
                    ]),
                    const PersonalField(title: "Personal"),
                    const TextfieldTags(title: "Interests", initialList: ["Passion", "IT", "Acting"]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff007AFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                await context.read<AuthProvider>().submitForm(
                                      description: descriptionController.text,
                                      jobDetails: jobController.text,
                                      location: locationController.text,
                                      profession: professionController.text,
                                      userName: nameController.text,
                                      years: jobYearsController.text,
                                    );
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => const PeopleScreen()));
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
