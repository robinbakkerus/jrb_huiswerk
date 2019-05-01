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
    AppEvents.onStartStopTask(_onTaskStopOrStarted);
  }

  void _onScheduleTask(ScheduleTaskEvent event) {
    Task task = AppUtils.getTask(_appData.tasks, event.taskId);
    task.status = TaskStatusType.scheduled;
    task.dueDate = event.dueDate;
    AppUtils.updateTask(_appData.tasks, task);
    AppEvents.fireTasksReady();
  }

  void _onTaskStopOrStarted(StartStopTaskEvent event) {
    Task task = AppUtils.getTask(_appData.tasks, event.taskId);
    if (task != null) {
      _doStopOrStartTask(event, task);
    } else {
      print('task is null??');
      AppData().setStatus(AppStatusType.none);
      AppData().timerService.stop();
      AppEvents.fireTasksReady();
    }
  }

  void _doStopOrStartTask(StartStopTaskEvent event, Task task) {
     if (event.start) {
      _onStartActions(task);
    } else {
      _onStopActions(task);
    }
    AppUtils.updateTask(_appData.tasks, task);
    AppEvents.fireTasksReady();
  }

  void _onStartActions(Task task) {
    task.status = TaskStatusType.busy;
    AppData().setStatus(AppStatusType.busy);
    AppData().timerService.start();
  }

  void _onStopActions(Task task) {
    task.status = TaskStatusType.scheduled;
    AppData().setStatus(AppStatusType.waiting);
    AppData().timerService.stop();
    task.timeSpend += AppData().timerService.elapsedTime;
  }
}
