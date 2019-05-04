import 'package:flutter/material.dart';

import '../model/task.dart';
import '../service/task_intf.dart';
import '../events/app_events.dart';
import '../data/constants.dart';
import '../util/app_utils.dart';
import '../model/app_status.dart';
import '../service/timer_srv.dart';

class AppData {
  static final AppData _instance = new AppData._internal();
  factory AppData() => _instance;

  ITaskService _taskService = ITaskService();
  List<Task> _tasks;
  BuildContext _context;
  AppStatus _appStatus = AppStatus();
  TimerService _timerService = new TimerService();
  bool showedInitHelp = false;

  List<Task> get tasks => this._tasks;
  List<Task> get allScheduledTasks => AppUtils.allScheduledTasks(tasks);
  TimerService get timerService => _timerService;
  AppStatus get appStatus => _appStatus;

  BuildContext get context => _context;
  set context(BuildContext ctx) {
    _context = ctx;
  }

  double screenWidth, screenHeight;
  bool get isBusy => _appStatus.currentStatus == AppStatusType.busy;
  bool get isWaiting => _appStatus.currentStatus == AppStatusType.waiting;
  void setStatus(AppStatusType status) => _appStatus.currentStatus = status;

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
      schedTask.status = TaskStatusType.scheduled;
      AppEvents.fireTasksReady();
    }
  }
}
