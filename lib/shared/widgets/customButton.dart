import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/styles.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback onTap;
  final String color;
  final String text;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.height,
      required this.onTap,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: HexColor(color),
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
