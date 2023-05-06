import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/screens/onboarding_screen.dart';
import 'package:social_app/app/screens/splash_screen.dart';
import 'package:social_app/auth/providers/auth_provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/dashboard/screens/people_screen.dart';

class SocialApp extends StatelessWidget {
  SocialApp({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "SFProText"),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
