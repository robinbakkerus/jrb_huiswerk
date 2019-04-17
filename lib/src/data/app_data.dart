import '../model/task.dart';
import '../service/task_intf.dart';
import '../events/app_events.dart';

class AppData {
  static final AppData _instance = new AppData._internal();
  factory AppData() => _instance;

  ITaskService _taskService = ITaskService();
  List<Task> _tasks;
  List<Task> get tasks => this._tasks;
  
  double  screenWidth, screenHeight;

  AppData._internal() {
    AppEvents.onGetTasks(_onGetTasks);
  }

  void _onGetTasks(GetTasksEvent event) {
    _getTasks();
  }

  void _getTasks() async {
    this._tasks = await _taskService.getUserTasks(0);
    if (tasks != null) {
      AppEvents.fireTaskReady();
    }
  }

 
}