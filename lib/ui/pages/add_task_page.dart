import 'package:flutter/material.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/widgets/button.dart';
import '../../models/task.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _curDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now());
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 30)));
  int _reminder = 5;
  final List<int> _renimdList = [5, 10, 15, 20, 25];
  String _repeat = 'None';
  final List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('images/person.jpeg'),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Add task',
              style: headingStyle,
            ),
            InputField(
              title: 'Title',
              hint: 'Enter title here',
              controller: _titleController,
            ),
            InputField(
              title: 'Note',
              hint: 'Enter note here',
              controller: _noteController,
            ),
            InputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_curDate),
              widget: IconButton(
                onPressed: () => _getDate(),
                icon: const Icon(Icons.calendar_today_outlined),
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    title: 'Start time',
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () => _getTime(startTime: true),
                      icon: const Icon(Icons.alarm),
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: InputField(
                    title: 'End time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () => _getTime(startTime: false),
                      icon: const Icon(Icons.alarm),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            InputField(
              title: 'Remind',
              hint: '$_reminder minutes early',
              widget: DropdownButton(
                borderRadius: BorderRadius.circular(12),
                dropdownColor: primaryClr,
                items: _renimdList
                    .map<DropdownMenuItem<String>>(
                      (int val) => DropdownMenuItem<String>(
                        value: val.toString(),
                        child: Text(
                          '$val',
                          style: bodyStyle,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _reminder = int.parse(newValue!);
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 30,
                underline: const SizedBox(height: 0),
              ),
            ),
            InputField(
              title: 'Repeat',
              hint: _repeat,
              widget: DropdownButton(
                borderRadius: BorderRadius.circular(12),
                dropdownColor: primaryClr,
                items: _repeatList
                    .map<DropdownMenuItem<String>>(
                      (String val) => DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: bodyStyle,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _repeat = newValue!;
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                iconSize: 30,
                underline: const SizedBox(height: 0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Color',
                        style: titleStyle,
                      ),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _colorIndex = index;
                                });
                              },
                              child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: index == 0
                                      ? bluishClr
                                      : index == 1
                                          ? pinkClr
                                          : orangeClr,
                                  child: _colorIndex == index
                                      ? const Icon(
                                          Icons.done,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _addTaskAfterValidation();
                        _taskController.getTasks();
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _addTaskToDB() async {
    await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_curDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _colorIndex,
      remind: _reminder,
      repeat: _repeat,
    ));
  }

  void _addTaskAfterValidation() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'WARNING',
        'There is an empty field.',
        colorText: Get.isDarkMode ? white : darkGreyClr,
        backgroundColor: Get.isDarkMode ? darkGreyClr : white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
        titleText: Text(
          'WARNING',
          style: titleStyle,
        ),
        messageText: Text(
          'There is an empty field.',
          style: bodyStyle,
        ),
        borderWidth: 0.5,
        borderColor: Colors.red,
      );
    } else {
      _addTaskToDB();
      Get.back();
    }
  }

  _getDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _curDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    setState(() {
      if (selectedDate != null) {
        _curDate = selectedDate;
      } else {
        debugPrint('no date selected');
      }
    });
  }

  _getTime({required bool startTime}) async {
    TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: startTime
            ? TimeOfDay.now()
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 30))));
    setState(() {
      if (selectedTime != null) {
        startTime
            ? _startTime = selectedTime.format(context)
            : _endTime = selectedTime.format(context);
      } else {
        debugPrint('no time selected');
      }
    });
  }
}
