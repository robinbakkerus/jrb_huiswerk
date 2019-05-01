import 'package:event_bus/event_bus.dart';

/*
 * All Events are maintainded here.
 */
class TasksReadyEvent {}

class GetTasksEvent {}

class ScheduleTaskEvent {
  int taskId;
  DateTime dueDate;
  ScheduleTaskEvent(this.taskId, this.dueDate);
}

class StartStopTaskEvent {
  int taskId;
  bool start;
  StartStopTaskEvent(this.taskId, this.start);
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
  static void fireStartTask(int taskId) => _sEventBus.fire(new StartStopTaskEvent(taskId, true));
  static void fireStopTask() => _sEventBus.fire(new StartStopTaskEvent(-1, false));
  static void fireTick(int elapsed) => _sEventBus.fire(new TimeTickEvent(elapsed));

  static void onTaskReady(OnTaskReadyFunc func) =>
      _sEventBus.on<TasksReadyEvent>().listen((event) => func(event));
  static void onGetTasks(OnGetTasksFunc func) =>
      _sEventBus.on<GetTasksEvent>().listen((event) => func(event));
  static void onScheduleTask(OnScheduledTaskFunc func) =>
      _sEventBus.on<ScheduleTaskEvent>().listen((event) => func(event));
  static void onStartStopTask(OnStartStopTaskFunc func) =>
      _sEventBus.on<StartStopTaskEvent>().listen((event) => func(event));
  static void onTick(OnHandleTickFunc func) =>
      _sEventBus.on<TimeTickEvent>().listen((event) => func(event));
}

typedef void OnTaskReadyFunc(TasksReadyEvent event);
typedef void OnGetTasksFunc(GetTasksEvent event);
typedef void OnScheduledTaskFunc(ScheduleTaskEvent event);
typedef void OnStartStopTaskFunc(StartStopTaskEvent event);
typedef void OnHandleTickFunc(TimeTickEvent event);