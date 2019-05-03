import '../data/constants.dart';
import '../util/app_utils.dart';

class Task {
  int id;
  int userId;
  TaskType type;
  TaskStatusType status = TaskStatusType.newtask;
  DateTime dueDate;
  int _expEffort = 0; // verwachte tijd in minuten
  int expEffortInitial;
  int timeSpend = 0; // tijd in mins die er aan besteerd is

  Task(this.id, this.userId, this.type, this.expEffortInitial) {
    this._expEffort = this.expEffortInitial;
  }

  Task.map(dynamic obj) {
    this.id = obj["id"];
    this.userId = obj["userId"];
    this.type = obj["type"];
    this.status = obj["status"];
    this.dueDate = obj["dueDate"];
    this.expEffortInitial = obj["expEffortInitial"];
    this.timeSpend = obj["timeSpend"];
    this._expEffort = obj["expEffort"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = this.id;
    map["userId"] = this.userId;
    map["type"] = this.type;
    map["status"] = this.status;
    map["dueDate"] = this.dueDate;
    map["expEffort"] = this._expEffort;
    map["expEffortInitial"] = this.expEffortInitial;
    map["timeSpend"] = this.timeSpend;
    return map;
  }

  String infoMsg() {
    StringBuffer sb = StringBuffer();
    sb.write(Constants.taskInfoMap[this.type] + '\n');
    sb.write('Geschat hiervoor : ' + this.expEffort.toString() + '\n');
    sb.write('Gedaan tot nu  : ' + this.timeSpend.toString() + '\n');
    sb.write('Te doen vandaag :' + this.todoPerDay().toString());
    return sb.toString();
  }

  int todoPerDay() {
    double d = (this._expEffort - this.timeSpend) /
        AppUtils.daysLeft(this, DateTime.now());
    return d.ceil();
  }

  int get expEffort => this._expEffort;

  set expEffort(int val) {
    this._expEffort = val;
    if (val == 0) {
      this.status = TaskStatusType.finished;
    }
  }

  bool get isDone => this.status == TaskStatusType.finished;
}
