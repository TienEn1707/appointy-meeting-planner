import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

class CustomAppBar2 extends PreferredSize {
  final String title;

  CustomAppBar2({super.key, required this.title})
      : super(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: darkGreyClr.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 20,
                      bottom: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: bgColor,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/icon_images/back_icon.svg',
                                color: primaryClr1,
                                width: 26,
                                height: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        title,
                        style: customAppBar,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}
