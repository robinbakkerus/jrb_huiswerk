import '../model/task.dart';
import '../service/task_intf.dart';
import '../events/app_events.dart';
import '../data/constants.dart';

class AppData {
  static final AppData _instance = new AppData._internal();
  factory AppData() => _instance;

  ITaskService _taskService = ITaskService();
  List<Task> _tasks;
  List<Task> get tasks => this._tasks;
  
  double  screenWidth, screenHeight;

  AppData._internal() {
    AppEvents.onGetTasks(_onGetTasks);
    // AppEvents.onScheduleTask(_onScheduleTask);
  }

  void _onGetTasks(GetTasksEvent event) {
    _getTasks();
  }

  // void _onScheduleTask(ScheduleTaskEvent event) {
  //   print("TODO sched appdata " + event.taskId.toString());
  // }

  void _getTasks() async {
    this._tasks = await _taskService.getUserTasks(0);
    if (tasks != null) {
      AppEvents.fireTasksReady();
    }
  }

  void scheduleTask(int taskId, DateTime dueDate) {
    Task schedTask = _tasks.firstWhere((t) => t.id == taskId);
    if (schedTask != null) {
      schedTask.dueDate = dueDate;
      schedTask.status = TaskStatus.scheduled;
      AppEvents.fireTasksReady();
    }
  }
 
}