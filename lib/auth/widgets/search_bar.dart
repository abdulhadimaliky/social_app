import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: TextField(
        cursorColor: Colors.black54,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff007AFF).withOpacity(0.05),
          prefixIcon: const Icon(Icons.search, color: Color(0xff007AFF)),
          hintText: "Search...",
          hintStyle: TextStyle(color: const Color(0xff007AFF).withOpacity(0.7)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
