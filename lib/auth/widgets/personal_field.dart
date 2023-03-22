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
        Container(
          width: MediaQuery.of(context).size.width * 0.93,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff007AFF)),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            children: [
              Image.asset("assets/motivation.png"),
              Image.asset("assets/passion.png"),
            ],
          ),
        ),
      ],
    );
  }
}
