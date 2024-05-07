import 'dart:developer';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];
  List<CompletedTask> completedTasks = [];
  late Database _database;
  late Database _database2;

  String? taskName;
  final dateCont = TextEditingController();
  final timeCont = TextEditingController();
  int currentIndex = 0;

  setTaskName(String? value) {
    taskName = value;
    log(value.toString());
    notifyListeners();
  }

  setPageIndex(int value) {
    currentIndex = value;
    notifyListeners();
  }

  setDate(DateTime? date) {
    if (date == null) {
      return;
    }
    log(date.toString());

    DateTime currentDate = DateTime.now();
    DateTime now =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    int diff = date.difference(now).inDays;

    if (diff == 0) {
      dateCont.text = "Today";
    } else if (diff == 1) {
      dateCont.text = "Tommorrow";
    } else {
      dateCont.text = "${date.day}-${date.month}-${date.year}";
    }

    notifyListeners();
  }

  setTime(TimeOfDay? time) {
    log(time.toString());
    if (time == null) {
      return;
    }

    if (time.hour == 0) {
      timeCont.text = "12:${time.minute} AM";
    } else if (time.hour < 12) {
      timeCont.text = "${time.hour}:${time.minute} AM";
    } else if (time.hashCode == 12) {
      timeCont.text = "${time.hour}:${time.minute} PM";
    } else {
      timeCont.text = "${time.hour - 12}:${time.minute} PM";
    }

    notifyListeners();
  }

  Future<void> getTodos(int database) async {
    final List<Map<String, dynamic>> maps = database == 1
        ? await _database.query('todos')
        : await _database2.query('done');

    if (database == 1) {
      tasks = List.generate(maps.length, (i) {
        return Task(maps[i]['taskName'], maps[i]['date'], maps[i]['time']);
      });
    } else {
      completedTasks = List.generate(maps.length, (i) {
        return CompletedTask(maps[i]['taskName']);
      });
    }
    notifyListeners();
  }

  Future<void> insertTodo(Task task) async {
    await _database.insert(
      'todos',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> taskCompleted(Task task, taskName) async {
    CompletedTask completedTask = CompletedTask(taskName);
    await _database.delete(
      'todos',
      where: "taskName =?",
      whereArgs: [task.taskName],
    );
    await initDatabase2();
    await _database2.insert(
      'done',
      completedTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('task completed successfully');
    notifyListeners();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database1.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(taskName TEXT, date TEXT, time TEXT)",
        );
      },
      version: 1,
    );
    getTodos(1);
  }

  Future<void> initDatabase2() async {
    _database2 = await openDatabase(
      join(await getDatabasesPath(), 'todo_database2.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE done(taskName TEXT)",
        );
      },
      version: 1,
    );

    await getTodos(2);
  }
}
