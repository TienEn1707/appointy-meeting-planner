import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/task_controller.dart';
import '../pages/add_company_page.dart';
import '../pages/add_task_page.dart';
import '../theme.dart';

void showAddOptionModal(BuildContext context, TaskController taskController) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.only(
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
              svgAsset: 'assets/images/icon_images/company_icon.svg',
              title: 'Add Company',
              onTap: () async {
                Navigator.of(context).pop();
                await Get.to(() => const AddCompanyPage());
                taskController.getTasks();
              },
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              context: context,
              svgAsset: 'assets/images/icon_images/activity_icon.svg',
              title: 'Add Meeting',
              onTap: () async {
                Navigator.of(context).pop();
                await Get.to(() => const AddTaskPage());
                taskController.getTasks();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

Widget _buildOptionTile({
  required BuildContext context,
  required String svgAsset,
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
          SvgPicture.asset(
            svgAsset,
            color: primaryClr1,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: customTitle,
          ),
        ],
      ),
    ),
  );
}
