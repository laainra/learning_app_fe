import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  // final Color iconColor;
  final VoidCallback onPressed;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.bgColor,
    // required this.iconColor,
    required this.onPressed,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
