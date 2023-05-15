import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    required this.screenTitle,
    this.endIcon,
    Key? key,
  }) : super(key: key);

  final String screenTitle;
  final Widget? endIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        Text(screenTitle),
        SizedBox(width: 50, child: endIcon)
      ],
    );
  }
}
