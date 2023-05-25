import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/screens/edit_profile_screen.dart';
import 'package:social_app/auth/widgets/primary_button.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';
import 'package:social_app/auth/widgets/signup_with.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 20, color: const Color(0xff111129).withOpacity(0.5)),
                      ),
                      const Text(
                        "Sign in Now",
                        style: TextStyle(fontSize: 36),
                      ),
                    ],
                  ),
                  Text(
                    "Sign in to continue your social networking",
                    style: TextStyle(color: const Color(0xff111129).withOpacity(0.5)),
                  ),
                  SignupTitleAndTextField(
                    fieldSize: "full",
                    title: "Email or Username",
                    hintText: "yourname@email.com",
                    validate: (email) {
                      if (email == null || email.isEmpty) return 'E-mail address is required.';
                      String pattern = r'\w+@\w+\.\w+';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(email)) return 'Invalid E-mail Address format.';

                      return null;
                    },
                    controller: emailController,
                  ),
                  SignupTitleAndTextField(
                    fieldSize: "full",
                    obscure: true,
                    title: "Your password",
                    hintText: "****",
                    validate: (password) {
                      if (password == null || password.isEmpty) return 'Password is required.';

                      return null;
                    },
                    controller: passwordController,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Text("Forgot Password?")],
                  ),
                  PrimaryButton(
                      onpressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await context.read<AuthProvider>().signin(emailController.text, passwordController.text);
                            final user = await context.read<AuthProvider>().checkUserInDB();
                            if (user == null) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PeopleScreen()));
                            }
                          } on FirebaseAuthException catch (error) {
                            errorMessage = error.message!;
                            setState(() {
                              errorMessage = error.message!;
                            });
                          }
                        }
                      },
                      title: "Sign in"),
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SignupWith(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: const Color(0xff111129).withOpacity(0.5),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            // print(FirebaseAuth.instance.currentUser!.uid);
                          },
                          child: const Text("Sign Up"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
