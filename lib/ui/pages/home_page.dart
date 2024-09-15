import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/gradients/gradient_button.dart';
import '../widgets/add_option_modal.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_date_bar.dart';
import '../widgets/task_tile.dart';
import '../size_config.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  late Timer _dailyTimer;
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _requestAndroidPermissions();
    _taskController.getTasks();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _taskController.checkUpcomingMeetings();
    });
    _currentDate = DateTime.now();
    _setupDailyReset();
  }

  void _setupDailyReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = nextMidnight.difference(now);

    _dailyTimer = Timer(timeUntilMidnight, () {
      setState(() {
        _currentDate = DateTime.now();
        _selectedDate = _currentDate;
      });
      _taskController.resetShownMeetings();
      _taskController.getTasks();
      _setupDailyReset();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _dailyTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryClr1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _addTaskBar(),
                  _addDateBar(),
                  _addTaskShow(),
                  const SizedBox(height: 8),
                  _showTasks(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GradientButton(
          icon: const Icon(
            Icons.add,
            color: white,
          ),
          text: 'Add',
          onPressed: () async {
            showAddOptionModal(context, _taskController);
          },
          gradientColors: gradientClr3,
          width: 130,
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Application'),
          content: const Text('Are you sure you want to exit the application?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 16, color: darkGreyClr)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            GradientButton(
              text: 'Yes',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              gradientColors: gradientClr3,
              width: 76,
              height: 46,
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/images/icon_images/calendar_icon.svg',
              color: primaryClr1,
              width: 24,
              height: 24,
            ),
          ),
          Text(DateFormat.yMMMMd().format(DateTime.now()),
              style: customTextHome1),
          const SizedBox(width: 6),
          Text('(Today)', style: customTextHome1),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 0, top: 0),
      child: CustomDatePicker(
        startDate: DateTime.now(),
        selectedDate: _selectedDate,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  Future<void> _requestAndroidPermissions() async {
    List<Permission> permissions = [
      Permission.notification,
      Permission.calendar,
    ];

    for (var permission in permissions) {
      if (await permission.isGranted) {
        debugPrint('${permission.toString()} already granted.');
      } else {
        final status = await permission.request();
        debugPrint('${permission.toString()} status: ${status.toString()}');
      }
    }
  }

  _addTaskShow() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/images/icon_images/activity_icon.svg',
              color: primaryClr1,
              width: 24,
              height: 24,
            ),
          ),
          Text('Activity', style: customTextHome1),
        ],
      ),
    );
  }

  Widget _showTasks() {
    return Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noMeetingMsg();
      } else {
        var sortedTasks = _taskController.taskList.toList()
          ..sort((a, b) {
            int dateComparison = a.date!.compareTo(b.date!);
            if (dateComparison != 0) return dateComparison;
            return a.startTime!.compareTo(b.startTime!);
          });

        var tasksForSelectedDate = sortedTasks
            .where((task) =>
                task.date == DateFormat.yMd().format(_selectedDate) &&
                task.isCompleted == 0)
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            var task = tasksForSelectedDate[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1400),
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () => _showBottomSheet(context, task),
                    child: TaskTile(task),
                  ),
                ),
              ),
            );
          },
          itemCount: tasksForSelectedDate.length,
        );
      }
    });
  }

  Widget _noMeetingMsg() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: SizeConfig.orientation == Orientation.landscape
          ? Axis.vertical
          : Axis.vertical,
      children: [
        SizeConfig.orientation == Orientation.landscape
            ? const SizedBox(height: 50)
            : const SizedBox(height: 50),
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
        SizeConfig.orientation == Orientation.landscape
            ? const SizedBox(height: 180)
            : const SizedBox(height: 180),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    showTaskBottomSheet(context, task, _taskController);
  }
}
