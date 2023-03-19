import 'package:flutter/cupertino.dart';

class SignupWith extends StatelessWidget {
  const SignupWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Or Via Social Media"),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/facebook.png"),
            Image.asset("assets/Wechat.png"),
            Image.asset("assets/Google.png"),
          ],
        )
      ],
    );
  }
}
