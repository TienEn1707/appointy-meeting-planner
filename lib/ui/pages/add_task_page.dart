import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/task_controller.dart';
import '../../controllers/company_controller.dart';
import '../../models/task.dart';
import '../../models/company.dart';
import '../widgets/gradients/gradient_button.dart';
import '../widgets/custom_app_bar2.dart';
import '../widgets/custom_snackBar.dart';
import '../widgets/input_field.dart';
import '../theme.dart';
import 'home_page.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final CompanyController _companyController = Get.put(CompanyController());

  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('HH:mm').format(DateTime.now()).toString();
  String _endTime = DateFormat('HH:mm')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  int _selectedColor = 0;

  Company? _selectedCompany;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(
        title: 'Add Meeting',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (_companyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return InputField(
                  title: 'Company Name',
                  hint: 'Select a company',
                  isDropdown: true,
                  dropdownItems:
                      _companyController.companyList.map((Company company) {
                    return DropdownMenuItem<Company>(
                      value: company,
                      child:
                          Text(company.companyName ?? '', style: subTitleStyle),
                    );
                  }).toList(),
                  dropdownValue: _selectedCompany,
                  onDropdownChanged: (dynamic newValue) {
                    setState(() {
                      _selectedCompany = newValue as Company?;
                    });
                  },
                  dropdownMaxHeight: 200,
                );
              }),
              InputField(
                title: 'Agenda',
                hint: 'Enter agenda here',
                controller: _noteController,
                hintOpacity: 0.4,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                readOnly: true,
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
                      readOnly: true,
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
                      readOnly: true,
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
                  text: 'Create Meeting',
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
    if (_selectedCompany != null) {
      bool exists = await _taskController.isMeetingExists(
          DateFormat.yMd().format(_selectedDate), _startTime, _endTime);
      if (exists) {
        CustomSnackbar.showFailed('A meeting already exists at this time!');
      } else {
        await _addTasksToDb();
        Future.delayed(const Duration(seconds: 3), () {
          Get.back();
        });
      }
    } else {
      CustomSnackbar.showRequired('All fields are required!');
    }
  }

  _addTasksToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          companyName: _selectedCompany!.companyName,
          note: _noteController.text.isEmpty ? '-' : _noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
        ),
      );

      CustomSnackbar.showSuccess('Meeting added successfully!');

      Get.offAll(
        () => const HomePage(),
        transition: Transition.fadeIn,
      );

      debugPrint('Task added with ID: $value');
    } catch (e) {
      debugPrint('Error adding task: $e');
      CustomSnackbar.showFailed('Failed to add meeting. Please try again.');
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
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
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
