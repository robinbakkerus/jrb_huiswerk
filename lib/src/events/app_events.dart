import 'package:event_bus/event_bus.dart';

import '../model/task.dart';

/*
 * All Events are maintainded here.
 */
class TasksReadyEvent {}

class GetTasksEvent {}

abstract class BaseTaskEvent {
  Task task;
  BaseTaskEvent(this.task);
}

class ScheduleTaskEvent {
  int taskId;
  DateTime dueDate;
  ScheduleTaskEvent(this.taskId, this.dueDate);
}

class StartTaskEvent extends BaseTaskEvent {
  StartTaskEvent(task) : super(task);
}

class StopTaskEvent extends BaseTaskEvent {
  StopTaskEvent(task) : super(task);
}

class AskTaskProgressEvent {
}

class TimeTickEvent {
  int elapsed;
  TimeTickEvent(this.elapsed);
}

class AppEvents {
  static final EventBus _sEventBus = new EventBus();

  // Only needed if clients want all EventBus functionality.
  // static EventBus ebus() => _sEventBus;

  /*
  * The methods below are just convenience shortcuts to make it easier for the client to use.
  */
  static void fireTasksReady() => _sEventBus.fire(new TasksReadyEvent());
  static void fireGetTasks() => _sEventBus.fire(new GetTasksEvent());
  static void fireScheduleTasks(int taskId, DateTime dueDate) => _sEventBus.fire(new ScheduleTaskEvent(taskId, dueDate));
  static void fireStartTask(Task task) => _sEventBus.fire(new StartTaskEvent(task));
  static void fireStopTask(Task task) => _sEventBus.fire(new StopTaskEvent(task));
  static void fireAskTaskProgress() => _sEventBus.fire(new AskTaskProgressEvent());
  static void fireTick(int elapsed) => _sEventBus.fire(new TimeTickEvent(elapsed));

  static void onTaskReady(OnTaskReadyFunc func) =>
      _sEventBus.on<TasksReadyEvent>().listen((event) => func(event));
  static void onGetTasks(OnGetTasksFunc func) =>
      _sEventBus.on<GetTasksEvent>().listen((event) => func(event));
  static void onScheduleTask(OnScheduledTaskFunc func) =>
      _sEventBus.on<ScheduleTaskEvent>().listen((event) => func(event));
  static void onStartTask(OnStartTaskFunc func) =>
      _sEventBus.on<StartTaskEvent>().listen((event) => func(event));
  static void onStopTask(OnStopTaskFunc func) =>
      _sEventBus.on<StopTaskEvent>().listen((event) => func(event));
  static void onAskTaskProgress(OnAskTaskProgressFunc func) =>
      _sEventBus.on<AskTaskProgressEvent>().listen((event) => func(event));
  static void onTick(OnHandleTickFunc func) =>
      _sEventBus.on<TimeTickEvent>().listen((event) => func(event));
}

typedef void OnTaskReadyFunc(TasksReadyEvent event);
typedef void OnGetTasksFunc(GetTasksEvent event);
typedef void OnScheduledTaskFunc(ScheduleTaskEvent event);
typedef void OnStartTaskFunc(StartTaskEvent event);
typedef void OnStopTaskFunc(StopTaskEvent event);
typedef void OnAskTaskProgressFunc(AskTaskProgressEvent event);
typedef void OnHandleTickFunc(TimeTickEvent event);