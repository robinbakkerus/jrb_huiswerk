import 'task_intf.dart';
import '../model/task.dart';
import '../data/constants.dart';

class TaskServiceMockImpl implements ITaskService {

  @override
  Future<List<Task>> getUserTasks(int userId) async {
    DateTime _dueDate = DateTime.now().add(Duration(days:4));
    Task _schedTask = Task(index++, index++, TaskType.rekenen, TaskStatus.scheduled, _dueDate, 90, 0);
    List<Task> _tasks = [_newTask(TaskType.geschiedenis, 120),
      _newTask(TaskType.techniek, 120),
      _newTask(TaskType.aardrijkskunde, 120), 
      _newTask(TaskType.nederlands, 60), _schedTask];
    return Future(() => _tasks);
  }

  static int index = 1;
  Task _newTask(TaskType t, int expeff) {
    return Task(index++, index++, t, TaskStatus.newtask, null, expeff, 0);
  }
}