import 'package:flutter/material.dart';

class SignupTitleAndTextField extends StatefulWidget {
  SignupTitleAndTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.validate,
    this.obscure = false,
    required this.controller,
  });

  final String title;
  final String hintText;
  final String? Function(String?) validate;
  bool obscure;
  final TextEditingController controller;

  @override
  State<SignupTitleAndTextField> createState() => _SignupTitleAndTextFieldState();
}

class _SignupTitleAndTextFieldState extends State<SignupTitleAndTextField> {
  bool _obscurePassword = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: TextFormField(
            onTap: () {
              if (widget.obscure == true) {
                setState(() {
                  _obscurePassword = true;
                });
              }
            },
            controller: widget.controller,
            obscureText: _obscurePassword,
            validator: widget.validate,
            decoration: InputDecoration(
              suffixIcon: widget.obscure == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: const Color(0xff007AFF).withOpacity(0.5),
                      ))
                  : null,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff007AFF),
                  )),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: const Color(0xff007AFF).withOpacity(0.5), fontSize: 14),
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
