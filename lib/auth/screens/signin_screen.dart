import 'package:flutter/material.dart';
import 'package:social_app/auth/widgets/primary_button.dart';
import 'package:social_app/auth/widgets/signup_title_and_textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
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
            Text(
              "Sign in to continue your social networking",
              style: TextStyle(color: const Color(0xff111129).withOpacity(0.5)),
            ),
            SignupTitleAndTextField(
              title: "Email or Username",
              hintText: "yourname@email.com",
              validate: (val) {},
              controller: emailController,
            ),
            SignupTitleAndTextField(
              obscure: true,
              title: "Your password",
              hintText: "****",
              validate: (val) {},
              controller: passwordController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [Text("Forgot Password?")],
            ),
            PrimaryButton(onpressed: () {}, title: "Sign in")
          ],
        ),
      )),
    );
  }
}
