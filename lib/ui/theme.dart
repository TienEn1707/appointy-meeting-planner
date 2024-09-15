import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color white = Colors.white;
const Color bgColor = Color(0xFFF6F6F6);
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

const Color blueClr = Color(0xFF4E5AE8);
const Color yellowClr = Color(0xFFFCA504);
const Color redClr = Color(0xFFF16A6F);
const Color primaryClr1 = Color(0xFF730A0A);
const Color primaryClr2 = Color(0xFF9A5615);
const Color shadowClr = Color(0x19000000);

const List<Color> gradientClr1 = [primaryClr1, primaryClr2];
const List<Color> gradientClr2 = [primaryClr2, primaryClr1];
const List<Color> gradientClr3 = [Color(0xFF260303), Color(0xFF5A0707)];
const List<Color> gradient_blueClr = [blueClr, Color(0xFF2C3382)];

class Themes {
  static final light = ThemeData(
    primaryColor: blueClr,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    scaffoldBackgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get getStarted {
  return GoogleFonts.inter(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 42,
      fontWeight: FontWeight.bold,
      letterSpacing: -2.0,
    ),
  );
}

TextStyle get customTitleAlarm {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.0,
    ),
  );
}

TextStyle get customAppBar {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.0,
    ),
  );
}

TextStyle get customTitle {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get customTextHome1 {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.0,
    ),
  );
}

TextStyle get customTextHome2 {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: -1.0,
    ),
  );
}

TextStyle get customTextCompany {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),
  );
}

TextStyle get subHomeStyle {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      color: primaryClr1,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.inter(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
