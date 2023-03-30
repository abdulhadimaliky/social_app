import 'package:flutter/material.dart';
import 'package:social_app/auth/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Color(0xffFFFFFF),
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: const [
                    Header(screenTitle: "People"),
                    SearchBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}