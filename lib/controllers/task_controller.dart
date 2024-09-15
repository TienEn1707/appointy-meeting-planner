import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/db_helper.dart';
import '../models/task.dart';
import '../ui/widgets/alarm_popup.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;
  final Set<int> _shownMeetings = {};
  final RxBool _isMuted = false.obs;
  final AlarmPopup _alarmPopup = AlarmPopup();

  @override
  void onInit() {
    super.onInit();
    getTasks();
    _loadMuteSetting();
  }

  @override
  void onClose() {
    _alarmPopup.dispose();
    super.onClose();
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  Future<void> updateTask(Task task) async {
    await DBHelper.updateTask(task);
    _shownMeetings.remove(task.id);
    await getTasks();
  }

  Future<void> deleteTask(Task task) async {
    await DBHelper.delete(task);
    await getTasks();
  }

  Future<void> deleteAllTasks() async {
    await DBHelper.deleteAll();
    await getTasks();
  }

  void markTaskCompletion(Task task, bool isCompleted) async {
    await DBHelper.updateTaskCompletion(task.id!, isCompleted);
    getTasks();
  }

  DateTime _parseDateTime(String date, String time) {
    final dateTime = DateFormat('M/d/y HH:mm').parse('$date $time');
    return dateTime;
  }

  DateTime _combineDateTime(DateTime date, String timeString) {
    final timeComponents = timeString.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeComponents[0]),
      int.parse(timeComponents[1]),
    );
  }

  Future<bool> isMeetingExists(
      String date, String startTime, String endTime) async {
    await getTasks();

    DateTime selectedDate = DateFormat.yMd().parse(date);
    DateTime selectedStartTime = _combineDateTime(selectedDate, startTime);
    DateTime selectedEndTime = _combineDateTime(selectedDate, endTime);

    return taskList.any((task) {
      DateTime taskDate = DateFormat.yMd().parse(task.date!);
      DateTime taskStartTime = _combineDateTime(taskDate, task.startTime!);
      DateTime taskEndTime = _combineDateTime(taskDate, task.endTime!);

      return taskDate.isAtSameMomentAs(selectedDate) &&
          ((taskStartTime.isAtSameMomentAs(selectedStartTime) &&
              taskEndTime.isAtSameMomentAs(selectedEndTime)) ||
              (taskStartTime.isBefore(selectedStartTime) ||
                  taskStartTime.isAtSameMomentAs(selectedStartTime)) &&
                  taskEndTime.isAfter(selectedStartTime) ||
              (taskStartTime.isBefore(selectedEndTime) &&
                  (taskEndTime.isAfter(selectedEndTime) ||
                      taskEndTime.isAtSameMomentAs(selectedEndTime))));
    });
  }

  Future<bool> isMeetingExistsExcludingCurrent(
      String date, String startTime, String endTime, int currentTaskId) async {
    await getTasks();

    DateTime selectedDate = DateFormat.yMd().parse(date);
    DateTime selectedStartTime = _combineDateTime(selectedDate, startTime);
    DateTime selectedEndTime = _combineDateTime(selectedDate, endTime);

    return taskList.any((task) {
      if (task.id == currentTaskId) return false;

      DateTime taskDate = DateFormat.yMd().parse(task.date!);
      DateTime taskStartTime = _combineDateTime(taskDate, task.startTime!);
      DateTime taskEndTime = _combineDateTime(taskDate, task.endTime!);

      return taskDate.isAtSameMomentAs(selectedDate) &&
          ((taskStartTime.isAtSameMomentAs(selectedStartTime) &&
              taskEndTime.isAtSameMomentAs(selectedEndTime)) ||
              (taskStartTime.isBefore(selectedStartTime) ||
                  taskStartTime.isAtSameMomentAs(selectedStartTime)) &&
                  taskEndTime.isAfter(selectedStartTime) ||
              (taskStartTime.isBefore(selectedEndTime) &&
                  (taskEndTime.isAfter(selectedEndTime) ||
                      taskEndTime.isAtSameMomentAs(selectedEndTime))));
    });
  }

  Future<void> _loadMuteSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted.value = prefs.getBool('isMuted') ?? false;
  }

  void setMuted(bool value) {
    _isMuted.value = value;
  }

  void resetShownMeetings() {
    _shownMeetings.clear();
  }

  void _showMeetingPopup(Task task) {
    try {
      final taskStartTime = _parseDateTime(task.date!, task.startTime!);
      final now = DateTime.now();
      final minutesUntilStart = taskStartTime.difference(now).inMinutes;

      _alarmPopup.showAlarmPopup(task, minutesUntilStart, _isMuted.value);
    } catch (e) {
      print('Error showing meeting popup: ${e.toString()}');
    }
  }

  void checkUpcomingMeetings() {
    final now = DateTime.now();
    taskList.forEach((task) {
      if (task.id == null ||
          task.date == null ||
          task.startTime == null ||
          task.isCompleted == 1) return;

      try {
        final taskStartTime = _parseDateTime(task.date!, task.startTime!);
        final reminderTime =
        taskStartTime.subtract(Duration(minutes: task.remind!));

        if (now.isAfter(reminderTime) &&
            now.isBefore(taskStartTime) &&
            !_shownMeetings.contains(task.id)) {
          _showMeetingPopup(task);
          _shownMeetings.add(task.id!);
        } else if (now.isAfter(reminderTime) &&
            now.isBefore(taskStartTime.add(Duration(minutes: 5))) &&
            !_shownMeetings.contains(task.id)) {
          _showMeetingPopup(task);
          _shownMeetings.add(task.id!);
        }
      } catch (e) {
        print('Error processing task: ${e.toString()}');
      }
    });
  }
}
