import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/gradients/gradient_button.dart';
import '../widgets/custom_app_bar2.dart';
import '../widgets/custom_snackBar.dart';
import '../widgets/input_field.dart';
import '../theme.dart';
import 'home_page.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  late TextEditingController _companyNameController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late String _startTime;
  late String _endTime;
  late int _selectedRemind;
  late int _selectedColor;
  late int _isCompleted;

  List<int> remindList = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    _companyNameController =
        TextEditingController(text: widget.task.companyName);
    _noteController = TextEditingController(text: widget.task.note);
    _selectedDate = DateFormat.yMd().parse(widget.task.date!);
    _startTime = widget.task.startTime!;
    _endTime = widget.task.endTime!;
    _selectedRemind = widget.task.remind!;
    _selectedColor = widget.task.color!;
    _isCompleted = widget.task.isCompleted ?? 0;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(
        title: 'Edit Meeting',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.5,
                child: InputField(
                  title: 'Company Name',
                  hint: widget.task.companyName ?? 'No company name',
                  controller: _companyNameController,
                  readOnly: true,
                  hintOpacity: 1.0,
                ),
              ),
              InputField(
                title: 'Agenda',
                hint: 'Enter agenda here',
                controller: _noteController,
                hintOpacity: 0.4,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                onTap: () => _getDateFromUser(),
                widget: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon_images/calendar_icon.svg',
                    color: darkGreyClr.withOpacity(0.4),
                  ),
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      onTap: () => _getTimeFromUser(isStartTime: true),
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded,
                            color: darkGreyClr.withOpacity(0.4)),
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      onTap: () => _getTimeFromUser(isStartTime: false),
                      widget: IconButton(
                        icon: Icon(Icons.access_time_rounded,
                            color: darkGreyClr.withOpacity(0.4)),
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: 'Select remind time',
                isDropdown: true,
                dropdownItems:
                    remindList.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value minutes early', style: subTitleStyle),
                  );
                }).toList(),
                dropdownValue: _selectedRemind,
                onDropdownChanged: (dynamic newValue) {
                  setState(() {
                    _selectedRemind = newValue as int;
                  });
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color',
                      style: customTitle.copyWith(letterSpacing: -1.0),
                    ),
                    const SizedBox(height: 4),
                    _colorPalette(),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Update Meeting',
                  gradientColors: gradientClr3,
                  onPressed: () => _validateData(),
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorPalette() {
    return Wrap(
      alignment: WrapAlignment.start,
      children: List<Widget>.generate(
        3,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: CircleAvatar(
              backgroundColor: index == 0
                  ? blueClr
                  : index == 1
                      ? yellowClr
                      : redClr,
              radius: 14,
              child: _selectedColor == index
                  ? const Icon(
                      Icons.done,
                      size: 16,
                      color: white,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  _validateData() async {
    bool exists = await _taskController.isMeetingExistsExcludingCurrent(
        DateFormat.yMd().format(_selectedDate),
        _startTime,
        _endTime,
        widget.task.id!);
    if (exists) {
      CustomSnackbar.showFailed('A meeting already exists at this time!');
    } else {
      await _updateTaskInDb();
      Future.delayed(const Duration(seconds: 3), () {
        Get.back();
      });
    }
  }

  _updateTaskInDb() async {
    try {
      await _taskController.updateTask(
        Task(
          id: widget.task.id,
          companyName: widget.task.companyName,
          note: _noteController.text.isEmpty ? '-' : _noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          isCompleted: _isCompleted,
        ),
      );

      debugPrint('Meeting updated successfully');
      CustomSnackbar.showSuccess('Meeting edited successfully!');

      Get.offAll(
        () => const HomePage(),
        transition: Transition.fadeIn,
      );
    } catch (e) {
      debugPrint('Error updating task: $e');
      CustomSnackbar.showFailed('Failed to update meeting. Please try again.');
    }
  }

  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    } else {
      debugPrint('Please select a date');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() => _startTime = formattedTime);
      } else {
        setState(() => _endTime = formattedTime);
      }
    } else {
      debugPrint('Time selection cancelled');
    }
  }
}
