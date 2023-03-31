import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    required this.screenTitle,
    Key? key,
  }) : super(key: key);

  final String screenTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        Text(screenTitle),
        const SizedBox(width: 50)
      ],
    );
  }
}
