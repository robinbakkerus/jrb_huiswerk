import '../data/app_data.dart';
import '../data/constants.dart';
import '../events/app_events.dart';
import '../util/app_utils.dart';
import '../model/task.dart';

class AppController {
  static final AppController _instance = new AppController.internal();
  factory AppController() => _instance;

  AppData _appData;
  
  AppController.internal() {
    _appData = AppData();
    AppEvents.onScheduleTask(_onScheduleTask);
  }

  void _onScheduleTask(ScheduleTaskEvent event) {
    print("TODO sched appctrl " + event.taskId.toString());
    Task task = AppUtils.getTask(_appData.tasks, event.taskId);
    task.status = TaskStatus.scheduled;
    task.dueDate = event.dueDate;
    AppUtils.updateTask(_appData.tasks, task);

    AppEvents.fireTasksReady();
  }
}