import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_database != null) {
      return;
    }
    String _path = await getDatabasesPath() + 'tasks.db';
    _database = await openDatabase(_path, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $_tableName('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'title STRING, note STRING, isCompleted INTEGER,'
          'date STRING, startTime STRING, endTime STRING,'
          'color INTEGER, remind INTEGER, repeat STRING)');
    });
  }

  static Future<int> insert(Task? task) async {
    return await _database!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    return await _database!
        .delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    return await _database!.delete(_tableName);
  }

  static Future<int> update(int id) async {
    return await _database!.rawUpdate('''
    UPDATE $_tableName
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() {
    return _database!.query(_tableName);
  }
}
