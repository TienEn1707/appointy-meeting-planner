import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmallLabel extends StatelessWidget {
  final String text;
  final Color colorLabel;
  final Icon? icon;
  final String? iconSvgPath;
  final double iconSpacing;
  final double fontSize;

  const SmallLabel({
    super.key,
    required this.text,
    required this.colorLabel,
    this.icon,
    this.iconSvgPath,
    this.iconSpacing = 6,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: colorLabel.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: colorLabel.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            SizedBox(width: iconSpacing),
          ] else if (iconSvgPath != null) ...[
            SvgPicture.asset(
              iconSvgPath!,
              color: colorLabel,
              width: 16,
              height: 16,
            ),
            SizedBox(width: iconSpacing),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorLabel,
              fontSize: fontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
