import 'package:event_bus/event_bus.dart';

/*
 * All Events are maintainded here.
 */
class TasksReadyEvent {
}

class GetTasksEvent {
}



class AppEvents {
  static final EventBus _sEventBus = new EventBus();

  // Only needed if clients want all EventBus functionality.
  // static EventBus ebus() => _sEventBus;

  /*
  * The methods below are just convenience shortcuts to make it easier for the client to use.
  */
  static void fireTaskReady() => _sEventBus.fire(new TasksReadyEvent());
  static void firegetTasks() => _sEventBus.fire(new GetTasksEvent());

  static void onTaskReady(OnTaskReadyFunc func) =>
      _sEventBus.on<TasksReadyEvent>().listen((event) => func(event));
  static void onGetTasks(OnGetTasksFunc func) =>
      _sEventBus.on<GetTasksEvent>().listen((event) => func(event));
}

typedef void OnTaskReadyFunc(TasksReadyEvent event);
typedef void OnGetTasksFunc(GetTasksEvent event);