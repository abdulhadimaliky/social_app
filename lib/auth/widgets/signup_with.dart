import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/screens/edit_profile_screen.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';

class SignupWith extends StatefulWidget {
  const SignupWith({super.key});

  @override
  State<SignupWith> createState() => _SignupWithState();
}

class _SignupWithState extends State<SignupWith> {
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Or via social media"),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/facebook.png"),
            Image.asset("assets/Wechat.png"),
            GestureDetector(
                onTap: () async {
                  try {
                    await context.read<AuthProvider>().signinWithGoogle();

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
                },
                child: Image.asset("assets/Google.png")),
          ],
        )
      ],
    );
  }
}
