class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      this.title,
      this.note,
      this.color,
      this.date,
      this.startTime,
      this.endTime,
      this.isCompleted,
      this.remind,
      this.repeat});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'color': color,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'iscompleted': isCompleted,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    color = json['color'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isCompleted = json['isCompleted'];
    remind = json['remind'];
    repeat = json['repeat'];
  }
}
