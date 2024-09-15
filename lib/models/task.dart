class Task {
  int? id;
  String? companyName;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? remind;
  int? color;
  int? isCompleted;

  Task({
    this.id,
    this.companyName,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.color,
    this.isCompleted = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'color': color,
      'isCompleted': isCompleted,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    remind = json['remind'];
    color = json['color'];
    isCompleted = json['isCompleted'];
  }
}
