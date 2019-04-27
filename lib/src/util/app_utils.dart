import '../model/task.dart';
import '../data/constants.dart';

class AppUtils {

  static int yearDayFromTask(Task task) {
    return yearDayFromDate(task.dueDate);
  }

  static int yearDayFromNow() {
    return yearDayFromDate(DateTime.now());
  }

  static int yearDayFromDate(DateTime dt) {
    if (dt == null) return -1;
    final diff = dt.difference(new DateTime(dt.year, 1, 1, 0, 0));
    final diffInDays = diff.inDays;
    return diffInDays;
  }

  static List<Task> newTasks(List<Task> tasks) => _findTasks(tasks, _isNewTask, 0);
  static List<Task> scheduledTasks(List<Task> tasks, int yearDay) => _findTasks(tasks, _isScheduledTask, yearDay);

  static List<Task> _findTasks(List<Task> tasks, Function(Task, int) func, int yearDay) {
    List<Task> r = tasks.where((t) => func(t, yearDay)).toList();
    return r;
  }

  static bool _isNewTask(Task task, int yearDay) => task.status == TaskStatus.newtask;

  static bool _isScheduledTask(Task task, int yearDay) {
    return task.status == TaskStatus.scheduled;// && yearDay < AppUtils.yearDayFromTask(task); 
  }


  static List<DateTime> calDays() {
    List<DateTime> r = List();
    for (int i=0; i<7; i++) {
      r.add(DateTime.now().add(Duration(days: i)));
    }
    return r;
  }
  
  static String dayHdr(DateTime date) {
    return Constants.dayHeaders[date.weekday];
  }
}