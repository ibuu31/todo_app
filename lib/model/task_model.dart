class Task {
  String taskName;
  String date;
  String time;

  Task(this.taskName, this.date, this.time);
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'date': date,
      'time': time,
    };
  }
}

class CompletedTask {
  String taskName;
  CompletedTask(this.taskName);
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
    };
  }
}
