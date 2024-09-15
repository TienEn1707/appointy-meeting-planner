import 'package:flutter/material.dart';
import '../../theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double width;
  final double height;
  final Icon? icon;
  final double iconSpacing;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradientColors,
    this.width = double.infinity,
    this.height = 57,
    this.icon,
    this.iconSpacing = 3,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: darkGreyClr.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: iconSpacing),
            Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
            ),
          ],
        ),
      ),
    );
  }
}
