import 'package:flutter/material.dart';

class GradientTitle extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> gradientColors;

  const GradientTitle({
    super.key,
    required this.text,
    required this.style,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
