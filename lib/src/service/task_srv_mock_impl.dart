import 'task_intf.dart';
import '../model/task.dart';
import '../data/constants.dart';

class TaskServiceMockImpl implements ITaskService {

  @override
  Future<List<Task>> getUserTasks(int userId) async {
    DateTime _dueDate = DateTime.now().add(Duration(days:4));
    Task _schedTask = Task(index++, index++, TaskType.rekenen, TaskStatus.scheduled, _dueDate, 0, 0);
    List<Task> _tasks = [_newTask(TaskType.geschiedenis), _newTask(TaskType.nederlands), _schedTask];
    return Future(() => _tasks);
  }

  static int index = 0;
  Task _newTask(TaskType t) {
    return Task(index++, index++, t, TaskStatus.newtask, null, 0, 0);
  }
}