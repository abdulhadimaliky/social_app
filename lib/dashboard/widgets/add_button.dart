import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key, required this.userId}) : super(key: key);

  final String userId;

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
        onPressed: () async {
          await context.read<DashboardProvider>().sendFriendRequest(widget.userId);
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
