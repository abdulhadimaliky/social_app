import 'package:flutter/material.dart';

class SignupTitleAndTextField extends StatelessWidget {
  const SignupTitleAndTextField(
      {super.key,
      required this.title,
      required this.hintText,
      required this.validate,
      this.obscure = false,
      required this.controller});

  final String title;
  final String hintText;
  final String? Function(String?) validate;
  final bool obscure;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validate,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff007AFF),
                  )),
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xff007AFF), fontSize: 14),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff007AFF),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
