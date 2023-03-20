import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:social_app/auth/screens/signin_screen.dart';
import 'package:social_app/auth/screens/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                items: onboardingList,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  viewportFraction: 1.0,
                  aspectRatio: 1.0,
                  enlargeFactor: 0.35,
                  enlargeCenterPage: false,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color(0xff007AFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                  },
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
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
                  child: const Text("Sign In")),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Widget> onboardingList = [
  Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/person.png"),
      const Text(
        "Privetly Connected",
        style: TextStyle(fontSize: 22),
      ),
      const Text(
        "Butterfly will allow you to contact your friend safe\nand privetly.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
      Image.asset("assets/Pagination1.png")
    ],
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/Illustration.png"),
      const Text(
        "Discover Forums",
        style: TextStyle(fontSize: 22),
      ),
      const Text(
        "Create or Discover a forum for discussion with your\nfriend and more people",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
      Image.asset("assets/2.png")
    ],
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset("assets/Illustration03.png"),
      const Text(
        "Build Your Audience",
        style: TextStyle(fontSize: 22),
      ),
      const Text(
        "Analyze your data, start promoting and build your\ngreat audience!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
      Image.asset("assets/3.png")
    ],
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: 320,
        child: Image.asset("assets/Illustration04.png"),
      ),
      const Text(
        "Detailed Contact Info",
        style: TextStyle(fontSize: 22),
      ),
      const Text(
        "Analyze your data, start promoting and build your\ngreat audience!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
      Image.asset("assets/4.png")
    ],
  ),
];
