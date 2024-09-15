import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../size_config.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final double hintOpacity;
  final bool isDropdown;
  final List<DropdownMenuItem<dynamic>>? dropdownItems;
  final Function(dynamic)? onDropdownChanged;
  final dynamic dropdownValue;
  final double? dropdownMaxHeight;
  final bool readOnly;

  const InputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    this.hintOpacity = 1.0,
    this.isDropdown = false,
    this.dropdownItems,
    this.onDropdownChanged,
    this.dropdownValue,
    this.dropdownMaxHeight,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: customTitle.copyWith(letterSpacing: -1.0),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            padding: const EdgeInsets.all(2),
            decoration: ShapeDecoration(
              color: white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.5,
                  color: darkGreyClr.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: shadowClr,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: isDropdown
                ? DropdownButtonFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14),
                      border: InputBorder.none,
                    ),
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: subTitleStyle.copyWith(
                          color: darkGreyClr.withOpacity(0.4)),
                    ),
                    value: dropdownValue,
                    items: dropdownItems,
                    onChanged: readOnly ? null : onDropdownChanged,
                    style: subTitleStyle,
                    menuMaxHeight: dropdownMaxHeight,
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                : Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          autofocus: false,
                          readOnly: readOnly || widget != null,
                          style: subTitleStyle,
                          cursorColor: Get.isDarkMode
                              ? Colors.grey[100]
                              : Colors.grey[700],
                          decoration: InputDecoration(
                            hintText: hint,
                            hintStyle: subTitleStyle.copyWith(
                              color:
                                  subTitleStyle.color?.withOpacity(hintOpacity),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            border: InputBorder.none,
                          ),
                          onTap: onTap,
                        ),
                      ),
                      widget ?? Container(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
