import '../model/task.dart';
import '../data/constants.dart';
import '../data/app_data.dart';

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
  static List<Task> allScheduledTasks(List<Task> tasks) => _findTasks(tasks, _isScheduledTask, -1);
  static List<Task> scheduledTasks(List<Task> tasks, int yearDay) => _findTasks(tasks, _isScheduledTask, yearDay);
  
  // sorteer eerst op duur en dan op type
  static void sortTasks(List<Task> tasks) {
    tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
  }

  static bool isDueDate(Task task, DateTime date) => yearDayFromTask(task) == yearDayFromDate(date);
  static bool isToday(DateTime date) => yearDayFromDate(date) == yearDayFromNow();

  static int daysLeft(Task task, DateTime date) {
    int d1 = yearDayFromTask(task);
    int d2 = yearDayFromDate(date);
    return d1 - d2;
  }

  static double dayPct(Task task, DateTime date) => 1.0 - 0.1 * AppUtils.daysLeft(task, date);
  
  static List<Task> _findTasks(List<Task> tasks, Function(Task, int) func, int yearDay) {
    List<Task> r = tasks.where((t) => func(t, yearDay)).toList();
    return r;
  }

  static bool _isNewTask(Task task, int yearDay) => task.status == TaskStatusType.newtask;

  static bool _isBusyTask(Task task, int yearDay) => task.status == TaskStatusType.busy;

  static bool _isScheduledTask(Task task, int yearDay) {
    return (task.status == TaskStatusType.scheduled || task.status == TaskStatusType.busy) 
      && yearDay <= AppUtils.yearDayFromTask(task); 
  }

  static Task getTask(List<Task> tasks, int taskId) {
    if (taskId > 0) {
      return tasks.firstWhere((t) => t.id == taskId);
    } else {
      return getBusyTask();
    }
  }

  static void updateTask(List<Task> tasks, Task task) {
    int idx = tasks.indexWhere((t) => t.id == task.id);
    if (idx >= 0) {
      tasks[idx] = task;
    }
  }

  static List<DateTime> calDays() {
    List<DateTime> r = List();
    for (int i=0; i<7; i++) {
      r.add(DateTime.now().add(Duration(days: i)));
    }
    return r;
  }
  
  static String dayHdr(DateTime date) {
    return Constants.dayHeaders[date.weekday] + "\n" + date.weekday.toString() +  " " + Constants.maand[date.month];
  }

  static int maxExpEffort() {
    return AppData().allScheduledTasks.reduce((c,n) => (n.expEffort > c.expEffort) ? n : c).expEffort;
  }

  static double calcEffort(Task task, DateTime date) {
    int maxEff = maxExpEffort();
    double r = (maxEff == 0) ? Constants.taskWidth() : (task.expEffort / maxEff) * Constants.taskWidth();
    r = r * AppUtils.dayPct(task, date);
    return r;
  }

  static double calcEffDone(Task task, DateTime date) {
    double eff = calcEffort (task, date);
    if (task.expEffort == 0) {
      return eff;
    }
    
    if ((task.timeSpend + 1) < task.expEffort) {
      num pct = (task.expEffort - task.timeSpend) / task.expEffort;
      return eff * pct;
    } else {
      return eff;
    }
  }

  static String schedImageName(Task task, DateTime date) {
    String r = imageName(task);
    if (task.status == TaskStatusType.busy && isToday(date)) {
      r = 'huiswerk.jpg';
    }
    return r;
  }

  static String imageName(Task task) => Constants.taskImageMap[task.type];

  static Task getBusyTask() {
    List<Task> r = _findTasks(AppData().tasks, _isBusyTask, -1);
    if (r.length == 1) {
      return r[0];
    } else if (r.length == 0) {
      return null;
    } else {
      print("Meer dan 1 busy tasks !!!");
      return null;
    }
  }
}