import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import '../widgets/button.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _date = DateTime.now();
  NotifyHelper notifyHelper = NotifyHelper();
  final TaskController _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    notifyHelper.requestIOSPermission();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
          },
          icon: Get.isDarkMode
              ? const Icon(
                  Icons.light_mode_outlined,
                  size: 24,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.dark_mode,
                  size: 24,
                  color: Colors.black,
                ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (_taskController.tasksList.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: Text(
                            'Are you sure you want to clear tasks list?',
                            style: titleStyle,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel',
                                style: bodyStyle,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                notifyHelper.cancelAllNotifications();
                                _taskController.deletAllTasks();
                                Get.back();
                              },
                              child: Text(
                                'Clear all',
                                style: bodyStyle.copyWith(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: Text(
                        'Your tasks list is already empty.',
                        style: titleStyle,
                      ),
                      content: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              primaryClr.withOpacity(0.7)),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'OK',
                          style: bodyStyle,
                        ),
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 26,
              )),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
        child: Column(
          children: [
            _taskBar(),
            const SizedBox(
              height: 10,
            ),
            _datePicker(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                (() {
                  if (_taskController.tasksList.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection:
                          SizeConfig.orientation == Orientation.portrait
                              ? Axis.vertical
                              : Axis.horizontal,
                      itemCount: _taskController.tasksList.length,
                      itemBuilder: (_, index) {
                        var task = _taskController.tasksList[index];
                        if (task.date == DateFormat.yMd().format(_date) ||
                            task.repeat == 'Daily' ||
                            (task.repeat == 'Weekly' &&
                                _date
                                            .difference(DateFormat.yMd()
                                                .parse(task.date!))
                                            .inDays %
                                        7 ==
                                    0) ||
                            (task.repeat == 'Monthly' &&
                                _date.day ==
                                    DateFormat.yMd().parse(task.date!).day)) {
                          var startTime =
                              DateFormat.jm().parse(task.startTime!);
                          var notificationTime =
                              DateFormat('hh:mm').format(startTime);
                          notifyHelper.scheduleNotification(
                            hour: int.parse(
                                notificationTime.toString().split(':')[0]),
                            minutes: int.parse(
                                notificationTime.toString().split(':')[1]),
                            task: task,
                          );
                          return AnimationConfiguration.staggeredList(
                            duration: const Duration(milliseconds: 1000),
                            position: index,
                            child: SlideAnimation(
                              horizontalOffset: 300,
                              child: FadeInAnimation(
                                child: TaskTile(task),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return _noTasksWidget();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: titleStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Today',
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
          label: '+ Task',
          onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTasks();
          },
        ),
      ],
    );
  }

  DatePicker _datePicker() {
    return DatePicker(
      DateTime.now(),
      width: 70,
      height: 100,
      selectionColor: primaryClr,
      selectedTextColor: white,
      monthTextStyle: bodyStyle.copyWith(fontSize: 12, color: Colors.grey[700]),
      dateTextStyle: titleStyle.copyWith(fontSize: 24, color: Colors.grey[700]),
      dayTextStyle: bodyStyle.copyWith(fontSize: 12, color: Colors.grey[700]),
      initialSelectedDate: DateTime.now(),
      onDateChange: ((selectedDate) => setState(() {
            _date = selectedDate;
          })),
    );
  }

  _noTasksWidget() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              SvgPicture.asset(
                'images/task.svg',
                height: 100,
                semanticsLabel: 'task',
                color: primaryClr.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "You don't have any tasks yet.",
                style: headingStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
