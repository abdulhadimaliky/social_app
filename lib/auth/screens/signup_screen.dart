import 'package:flutter/material.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';
import 'package:social_app/auth/widgets/signup_with.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                  Text(
                    "Create an",
                    style: TextStyle(fontSize: 20, color: const Color(0xff111129).withOpacity(0.5)),
                  ),
                  const Text(
                    "Account",
                    style: TextStyle(fontSize: 36),
                  ),
                  Text("Create an acount and get unlimited access\nto our app feature!",
                      style: TextStyle(
                        color: const Color(0xff111129).withOpacity(0.5),
                      )
                      // style: TextStyle(fontSize: 36),
                      ),
                  SignupTitleAndTextField(
                    title: "Your Full Name",
                    hintText: "Your Name",
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter your name";
                      }
                    },
                  ),
                  SignupTitleAndTextField(
                    title: "Your Email Address",
                    hintText: "Enter Your Email",
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Enter a valid email";
                      }
                    },
                  ),
                  SignupTitleAndTextField(
                    title: "Set password",
                    hintText: "Enter your password",
                    validate: (value) {
                      if (value!.length < 6) {
                        return "Password should be at least 6 characters";
                      }
                    },
                    obscure: true,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff007AFF),
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print("valid data");
                      } else {
                        print("enter valid email");
                      }
                      // if (SignupTitleAndTextField().key.currentState.validate()) {
                      // }
                    },
                    child: const Text("Sign Up"),
                  ),
                  const SignupWith(),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
