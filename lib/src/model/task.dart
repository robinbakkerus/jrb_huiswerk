import '../data/constants.dart';

class Task {
  int id;
  int userId;
  TaskType type;
  TaskStatus status;
  DateTime dueDate;
  int expEffort; // verwachte tijd in minuten
  int timeSpend; // tijd in mins die er aan besteerd is
  
  Task(this.id, this.userId, this.type, this.status, this.dueDate, this.expEffort, this.timeSpend);

  Task.map(dynamic obj) {
    this.id = obj["id"];
    this.userId = obj["userId"];
    this.type = obj["type"];
    this.status = obj["status"];
    this.dueDate = obj["dueDate"];
    this.expEffort = obj["expEffort"];
    this.timeSpend = obj["timeSpend"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = this.id;
    map["userId"] = this.userId;
    map["type"] = this.type;
    map["status"] = this.status;
    map["dueDate"] = this.dueDate;
    map["expEffort"] = this.expEffort;
    map["timeSpend"] = this.timeSpend;
    return map;
  }
}
