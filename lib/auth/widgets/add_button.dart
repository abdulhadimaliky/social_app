import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  Color color = Colors.blue;
  Color textColor = Colors.white;
  String text = "Add";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: () {
          setState(() {
            color = const Color(0xff34C791).withOpacity(0.1);
            textColor = const Color(0xff34C791);
            text = "Sent";
          });
        },
      ),
    );
  }
}
