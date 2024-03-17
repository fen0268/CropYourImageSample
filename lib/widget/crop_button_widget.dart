
import 'package:flutter/material.dart';

class CropButton extends StatelessWidget {
  const CropButton({
    super.key,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    required this.icon,
    required this.text,
    required this.color,
  });

  final Function()? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
