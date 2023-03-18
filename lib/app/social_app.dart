import 'package:flutter/material.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "SFProText"),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
