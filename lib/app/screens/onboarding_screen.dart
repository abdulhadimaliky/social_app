import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Image.asset("assets/person.png"),
              const Text(
                "Privetly Connected",
                style: TextStyle(fontSize: 22),
              ),
              const Text(
                "Butterfly will allow you to contact your friend safe\nand privetly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              Image.asset("assets/Pagination1.png")
            ],
          ),
        ),
      ),
    );
  }
}
