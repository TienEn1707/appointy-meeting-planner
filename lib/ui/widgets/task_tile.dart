import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../theme.dart';
import '../size_config.dart';
import 'small_label.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(18)),
      child: Container(
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(16)),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: shadowClr,
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0.00, -1.00),
                    end: const Alignment(0, 1),
                    colors: _getGradientColors(task.color),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.companyName!,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: primaryClr1,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SmallLabel(
                            text: '${task.startTime} - ${task.endTime}',
                            colorLabel: primaryClr1,
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: primaryClr1,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SmallLabel(
                            text: task.isCompleted == 1 ? 'COMPLETED' : 'TODO',
                            colorLabel: task.isCompleted == 1
                                ? const Color(0xFF07BD00)
                                : const Color(0xFF0038FF),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        task.note!,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: primaryClr1,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int? color) {
    Color baseColor = _getBGCLR(color);
    Color baseColor2 = _getBGCLR2(color);
    return [
      baseColor,
      baseColor2,
    ];
  }

  Color _getBGCLR(int? color) {
    switch (color) {
      case 0:
        return blueClr;
      case 1:
        return yellowClr;
      case 2:
        return redClr;
      default:
        return blueClr;
    }
  }

  Color _getBGCLR2(int? color) {
    switch (color) {
      case 0:
        return const Color(0xFF2C3382);
      case 1:
        return const Color(0xFF976203);
      case 2:
        return const Color(0xFF8B3D41);
      default:
        return const Color(0xFF2C3382);
    }
  }
}
