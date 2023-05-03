import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/auth/repo/auth_repo.dart';
import 'package:social_app/auth/screens/edit_profile_screen.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkCurrentUser();
    super.initState();
  }

  Future<void> checkCurrentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await context.read<AuthProvider>().checkUserInDB();
      if (context.read<AuthProvider>().user == null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PeopleScreen()));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (conext) => const OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Opacity(
        opacity: 0.5,
        child: Image.asset(
          "assets/splash.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
