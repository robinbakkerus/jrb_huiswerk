import '../data/app_data.dart';
import '../events/app_events.dart';

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
  }
}