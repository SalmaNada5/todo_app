import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> tasksList = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    tasksList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deletTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void deletAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  Future<void> makeTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
