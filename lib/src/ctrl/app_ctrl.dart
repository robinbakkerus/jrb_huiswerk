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
    AppEvents.onStartTask(_onTaskStarted);
    AppEvents.onAskTaskProgress(_onAskTaskProgress);
    AppEvents.onStopTask(_onTaskStopped);
  }

  void _onScheduleTask(ScheduleTaskEvent event) {
    Task task = AppUtils.getTask(_appData.tasks, event.taskId);
    task.status = TaskStatusType.scheduled;
    task.dueDate = event.dueDate;
    AppUtils.updateTask(_appData.tasks, task);
    AppEvents.fireTasksReady();
  }

  void _onTaskStarted(StartTaskEvent event) {
    print('_onTaskStarted');
    if (event.task != null) {
      event.task.status = TaskStatusType.busy;
      AppData().setStatus(AppStatusType.busy);
      AppData().timerService.start();
      AppUtils.updateTask(_appData.tasks, event.task);
      AppEvents.fireTasksReady();
    } else {
      _handleNullTask('start');
    }
  }

  void _onTaskStopped(StopTaskEvent event) {
    print('_onTaskStopped');
    Task _task = event.task;
    if (_task != null) {
      AppData().setStatus(AppStatusType.none);
      //AppData().timerService.stop();
      if (_task.status != TaskStatusType.finished) {
        _task.status = TaskStatusType.scheduled;
      }
      AppUtils.updateTask(_appData.tasks, _task);
      AppEvents.fireTasksReady();
    } else {
      _handleNullTask('stop');
    }
  }

  void _onAskTaskProgress(AskTaskProgressEvent event) {
    print('_onAskTaskProgress');
    Task _task = AppUtils.getBusyTask();
    if (_task != null) {
      AppData().setStatus(AppStatusType.waiting);
      AppData().timerService.stop();
      _task.timeSpend += AppData().timerService.elapsedTime;
      // AppUtils.updateTask(_appData.tasks, _task);
      //  AppEvents.fireTasksReady();
    } else {
      _handleNullTask("ask");
    }
  }

  void _handleNullTask(String msg) {
    print('task is null?? ' + msg);
    AppData().setStatus(AppStatusType.none);
    AppData().timerService.stop();
    AppEvents.fireTasksReady();
  }
}
