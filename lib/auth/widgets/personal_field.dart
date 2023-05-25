import 'package:flutter/material.dart';

class PersonalField extends StatelessWidget {
  const PersonalField({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.93,
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff007AFF)),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Image.asset("assets/passion.png"),
              ),
              Image.asset("assets/motivation.png"),
              // UserProfilePicture(file: Provider.of<AuthProvider>(context).file)
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
