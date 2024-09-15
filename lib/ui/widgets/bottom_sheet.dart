import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/task_controller.dart';
import '../../../models/task.dart';
import '../pages/edit_task_page.dart';
import '../theme.dart';
import 'custom_snackBar.dart';
import 'gradients/gradient_button.dart';

void showTaskBottomSheet(
    BuildContext context, Task task, TaskController taskController) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          _buildOptionTile(
            context: context,
            title: task.isCompleted == 1
                ? 'Mark as incomplete'
                : 'Mark as complete',
            onTap: () {
              taskController.markTaskCompletion(task, task.isCompleted == 0);
              Get.back();
            },
          ),
          const SizedBox(height: 16),
          _buildOptionTile(
            context: context,
            title: 'Edit meeting',
            onTap: () async {
              Get.back();
              await Get.to(() => EditTaskPage(task: task));
              taskController.getTasks();
            },
          ),
          const SizedBox(height: 24),
          _buildOptionTileWithoutBox(
            context: context,
            svgAsset: 'assets/images/icon_images/trash_icon.svg',
            title: 'Delete meeting',
            onTap: () => _showDeleteConfirmation(context, task, taskController),
          ),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

Widget _buildOptionTile({
  required BuildContext context,
  String? svgAsset,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        color: darkGreyClr.withOpacity(0.05),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (svgAsset != null)
            SvgPicture.asset(
              svgAsset,
              color: primaryClr1,
              width: 24,
              height: 24,
            ),
          if (svgAsset != null) SizedBox(width: 12),
          Text(
            title,
            style: customTitle,
          ),
        ],
      ),
    ),
  );
}

Widget _buildOptionTileWithoutBox({
  required BuildContext context,
  required String svgAsset,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: customTextHome1.copyWith(
                fontWeight: FontWeight.w300, letterSpacing: 0),
          ),
        ],
      ),
    ),
  );
}

void _showDeleteConfirmation(
    BuildContext context, Task task, TaskController taskController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Meeting'),
        content: const Text('Are you sure you want to delete this meeting?'),
        contentTextStyle: const TextStyle(fontSize: 14, color: darkGreyClr),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel',
                style: TextStyle(fontSize: 16, color: darkGreyClr)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          GradientButton(
            text: 'Yes',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            gradientColors: gradientClr3,
            width: 76,
            height: 46,
            onPressed: () async {
              taskController.deleteTask(task);
              Navigator.of(context).pop();
              Get.back();
              CustomSnackbar.showSuccess('The meeting successfully deleted!');
            },
          ),
        ],
      );
    },
  );
}
