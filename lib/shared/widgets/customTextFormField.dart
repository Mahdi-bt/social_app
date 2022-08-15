import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData prefixIcon;
  final String labelText;
  final String hintText;
  final TextEditingController myController;
  final IconData? suffixIcon;
  final bool obsecureText;
  const CustomTextFormField({
    Key? key,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
    required this.labelText,
    required this.myController,
    this.obsecureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText,
      cursorHeight: 20,
      autofocus: false,
      controller: myController,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Icon(suffixIcon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.lightBlue, width: 1.5),
        ),
      ),
    );
  }
}
