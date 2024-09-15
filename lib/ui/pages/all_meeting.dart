import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/custom_snackBar.dart';
import '../widgets/gradients/gradient_button.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/custom_app_bar2.dart';
import '../widgets/task_tile.dart';
import '../theme.dart';
import '../size_config.dart';

class AllMeetingPage extends StatefulWidget {
  const AllMeetingPage({super.key});

  @override
  State<AllMeetingPage> createState() => _AllMeetingPageState();
}

class _AllMeetingPageState extends State<AllMeetingPage> {
  final TaskController _taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskController.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(
        title: 'All Meetings',
      ),
      body: Column(
        children: [
          const SizedBox(width: 40),
          _addAllMeetingsBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: primaryClr1,
              child: _showAllMeetings(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addAllMeetingsBar() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today', style: customTitle.copyWith(letterSpacing: -1.0)),
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: customTextHome2.copyWith(
                      color: darkGreyClr.withOpacity(0.5))),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => _showDeleteAllConfirmation(context),
            icon: SvgPicture.asset(
              'assets/images/icon_images/trash_icon.svg',
              color: white,
              width: 20,
              height: 20,
            ),
            label: Text('Delete All',
                style: customTextHome2.copyWith(
                    color: white, fontSize: getProportionateScreenHeight(16))),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDA2424),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showAllMeetings() {
    return Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noMeetingMsg();
      } else {
        var sortedTasks = _taskController.taskList.toList()
          ..sort((a, b) {
            var dateComparison = DateFormat.yMd()
                .parse(b.date!)
                .compareTo(DateFormat.yMd().parse(a.date!));
            if (dateComparison != 0) return dateComparison;
            return DateFormat.Hm()
                .parse(a.startTime!)
                .compareTo(DateFormat.Hm().parse(b.startTime!));
          });

        return AnimationLimiter(
          child: ListView.builder(
            itemCount: sortedTasks.length,
            itemBuilder: (_, index) {
              Task task = sortedTasks[index];
              var date = DateFormat.yMd().parse(task.date!);
              var dateString = DateFormat.yMMMMd().format(date);

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1400),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    child: _TaskItem(
                      task: task,
                      dateString: dateString,
                      showDate: index == 0 ||
                          dateString !=
                              DateFormat.yMMMMd().format(DateFormat.yMd()
                                  .parse(sortedTasks[index - 1].date!)),
                      onTap: () => _showBottomSheet(context, task),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Meetings'),
          content: const Text('Are you sure you want to delete all meetings?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 16, color: darkGreyClr)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            GradientButton(
              text: 'Yes',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              gradientColors: gradientClr3,
              width: 76,
              height: 46,
              onPressed: () async {
                await _taskController.deleteAllTasks();
                Navigator.of(context).pop();
                CustomSnackbar.showSuccess(
                    'All meetings successfully deleted!');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _noMeetingMsg() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icon_images/task_icon.svg',
            color: primaryClr1.withOpacity(0.5),
            height: 70,
            semanticsLabel: 'No Meeting',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'There are no meetings scheduled.\nPlease add a new meeting!',
                style: subHomeStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    showTaskBottomSheet(context, task, _taskController);
  }

  Future<void> _onRefresh() async {
    await _taskController.getTasks();
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final String dateString;
  final bool showDate;
  final VoidCallback onTap;

  const _TaskItem({
    super.key,
    required this.task,
    required this.dateString,
    required this.showDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDate)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 26, bottom: 14),
            child: Text(
              dateString,
              style: customTextHome1,
            ),
          ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            child: TaskTile(task),
          ),
        ),
      ],
    );
  }
}
