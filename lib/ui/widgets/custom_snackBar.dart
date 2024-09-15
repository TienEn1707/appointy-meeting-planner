import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    Color textColor = white,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    IconData icon = Icons.warning_amber_rounded,
  }) {
    Get.snackbar(
      title,
      '',
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(
        icon,
        size: 28,
        color: textColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  static void showSuccess(String message) {
    show(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showRequired(String message) {
    show(
      title: 'Required',
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showFailed(String message) {
    show(
      title: 'Failed',
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.warning_amber_rounded,
    );
  }
}
