import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/size_config.dart';

import '../../controllers/task_controller.dart';

class TaskTile extends StatelessWidget {
  TaskTile(this.task, {Key? key}) : super(key: key);

  final Task task;
  final TaskController _taskController = Get.put(TaskController());
  final NotifyHelper notifyHelper = NotifyHelper();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            height: SizeConfig.orientation == Orientation.portrait
                ? task.isCompleted == 1
                    ? SizeConfig.screenHeight * 0.35
                    : SizeConfig.screenHeight * 0.45
                : task.isCompleted == 0
                    ? SizeConfig.screenHeight * 0.5
                    : SizeConfig.screenHeight * 0.9,
            color: Get.isDarkMode ? darkHeaderClr : white,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                (task.isCompleted == 1)
                    ? Container(
                        height: 10,
                      )
                    : _bottomSheetBuilder(
                        label: 'Task Completed',
                        onTap: () {
                          notifyHelper.cancelNotification(task);
                          _taskController.makeTaskCompleted(task.id!);
                          Get.back();
                        },
                        color: primaryClr,
                      ),
                _bottomSheetBuilder(
                  label: 'Delete Task',
                  onTap: () {
                    notifyHelper.cancelNotification(task);
                    _taskController.deletTask(task);
                    Get.back();
                  },
                  color: Colors.red,
                ),
                Divider(
                  thickness: 0.5,
                  color: Get.isDarkMode ? white : Colors.grey[900],
                ),
                _bottomSheetBuilder(
                  label: 'Cancel',
                  onTap: () => Get.back(),
                  color: primaryClr,
                ),
              ],
            ),
          ),
        ));
      },
      child: Container(
        width: SizeConfig.orientation == Orientation.portrait
            ? SizeConfig.screenWidth
            : SizeConfig.screenWidth / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _taskColor(),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.portrait ? 20 : 4,
          ),
        ),
        margin: SizeConfig.orientation == Orientation.portrait
            ? EdgeInsets.only(bottom: getProportionateScreenHeight(12))
            : EdgeInsets.only(right: getProportionateScreenWidth(12)),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_alarm_outlined,
                          size: 16,
                          color: white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${task.startTime} - ${task.endTime}',
                          style: bodyStyle.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      task.note!,
                      style: bodyStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 0.5,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                (task.isCompleted == 0) ? 'TODO' : 'Completed',
                style: bodyStyle.copyWith(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _taskColor() {
    switch (task.color) {
      case 0:
        return primaryClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return primaryClr;
    }
  }

  _bottomSheetBuilder({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClosed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        height: task.isCompleted == 0
            ? SizeConfig.screenHeight * 0.1
            : SizeConfig.screenHeight * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isClosed ? Colors.transparent : color,
          border: Border.all(
            color: isClosed
                ? Get.isDarkMode
                    ? Colors.grey
                    : white
                : color,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: titleStyle.copyWith(color: white),
          ),
        ),
      ),
    );
  }
}
