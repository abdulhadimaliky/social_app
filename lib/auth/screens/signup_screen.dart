import 'package:flutter/material.dart';
import 'package:social_app/auth/repo/auth_repo.dart';
import 'package:social_app/auth/screens/signin_screen.dart';
import 'package:social_app/auth/widgets/primary_button.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';
import 'package:social_app/auth/widgets/signup_with.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create an",
                          style: TextStyle(fontSize: 20, color: const Color(0xff111129).withOpacity(0.5)),
                        ),
                        const Text(
                          "Account",
                          style: TextStyle(fontSize: 36),
                        ),
                      ],
                    ),
                    Text(
                      "Create an acount and get unlimited access\nto our app feature!",
                      style: TextStyle(
                        color: const Color(0xff111129).withOpacity(0.5),
                      ),
                    ),
                    SignupTitleAndTextField(
                      controller: nameController,
                      title: "Your Full Name",
                      hintText: "Your Name",
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter your name";
                        }
                      },
                    ),
                    SignupTitleAndTextField(
                      controller: email,
                      title: "Your Email Address",
                      hintText: "Enter Your Email",
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Enter a valid email";
                        }
                      },
                    ),
                    SignupTitleAndTextField(
                      controller: pass,
                      title: "Set password",
                      hintText: "Enter your password",
                      validate: (value) {
                        if (value!.length < 6) {
                          return "Password should be at least 6 characters";
                        }
                      },
                      obscure: true,
                    ),
                    PrimaryButton(
                      onpressed: () async {
                        final credential = await AuthRepo().createUser(email.text, pass.text);
                        if (credential.user != null) {
                          print(credential);
                        } else {
                          print("enter valid data");
                        }
                      },
                      title: "Sign up",
                    ),
                    const SignupWith(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: const Color(0xff111129).withOpacity(0.5),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SigninScreen(),
                                ),
                              );
                            },
                            child: const Text("Sign in"))
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
