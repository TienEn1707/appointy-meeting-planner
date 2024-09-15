import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../models/task.dart';
import 'gradients/gradient_button.dart';
import 'gradients/gradient_title.dart';
import '../theme.dart';
import 'small_label.dart';

class AlarmPopup {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> showAlarmPopup(
      Task task, int minutesUntilStart, bool isMuted) async {
    try {
      await _playAlarmSound(isMuted);

      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth * 0.9;
                double maxHeight = constraints.maxHeight * 0.8;

                return Container(
                  width: maxWidth,
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  decoration: ShapeDecoration(
                    color: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        width: 2,
                        color: darkGreyClr.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: maxWidth * 0.075,
                          vertical: maxHeight * 0.05,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: maxWidth * 0.5,
                              height: maxWidth * 0.5,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/alarm_image.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(height: maxHeight * 0.03),
                            SizedBox(
                              width: maxWidth,
                              child: Text(
                                'Upcoming Meeting',
                                textAlign: TextAlign.center,
                                style: customTitleAlarm,
                              ),
                            ),
                            GradientTitle(
                              text: 'in $minutesUntilStart minutes!',
                              style: customTitleAlarm,
                              gradientColors: gradient_blueClr,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: maxWidth,
                          margin: EdgeInsets.symmetric(
                            horizontal: maxWidth * 0.075,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: maxWidth * 0.05,
                            vertical: maxHeight * 0.03,
                          ),
                          decoration: ShapeDecoration(
                            color: white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                              side: BorderSide(
                                width: 2,
                                color: darkGreyClr.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        task.companyName ?? 'N/A',
                                        style: customTextHome1,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: maxHeight * 0.02),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          SmallLabel(
                                            text:
                                                '${task.startTime ?? 'N/A'} - ${task.endTime ?? 'N/A'}',
                                            colorLabel: primaryClr1,
                                            icon: const Icon(
                                              Icons.access_time_rounded,
                                              color: primaryClr1,
                                              size: 16,
                                            ),
                                          ),
                                          SmallLabel(
                                            text: task.date ?? 'N/A',
                                            colorLabel: primaryClr1,
                                            iconSvgPath:
                                                'assets/images/icon_images/calendar_icon.svg',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: maxHeight * 0.02),
                                      Text(
                                        task.note ?? 'N/A',
                                        style: subHomeStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(maxWidth * 0.075),
                        child: SizedBox(
                          width: maxWidth,
                          child: GradientButton(
                            text: 'Okay',
                            gradientColors: gradientClr3,
                            onPressed: () async {
                              await _stopAlarmSound();
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      print('Error showing meeting popup: ${e.toString()}');
    }
  }

  Future<void> _playAlarmSound(bool isMuted) async {
    if (isMuted) return;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setSource(AssetSource('alarm_sound.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing alarm sound: ${e.toString()}');
    }
  }

  Future<void> _stopAlarmSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping alarm sound: ${e.toString()}');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
