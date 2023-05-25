import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  SettingItem({
    super.key,
    required this.icon,
    required this.itemTitle,
    required this.color,
    required this.iconColor,
  });

  IconData icon;
  String itemTitle;
  Color color;
  Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
        child: Icon(icon, size: 30, color: iconColor),
      ),
      title: Text(itemTitle),
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
