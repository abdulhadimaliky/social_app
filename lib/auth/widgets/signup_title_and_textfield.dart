import 'package:flutter/material.dart';

class SignupTitleAndTextField extends StatelessWidget {
  SignupTitleAndTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.validate,
    this.obscure = false,
    // this.suffixIcon = const IconButton(onPressed: () {

    // }, icon: Icon(Icons.remove_red_eye))
  });

  final String title;
  final String hintText;
  final String? Function(String?) validate;
  final bool obscure;
  // final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
          child: TextFormField(
            obscureText: obscure,
            validator: validate,
            decoration: InputDecoration(
              // suffixIcon: suffixIcon,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }
}
