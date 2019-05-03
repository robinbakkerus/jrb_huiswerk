import 'task_intf.dart';
import '../model/task.dart';
import '../data/constants.dart';

class TaskServiceMockImpl implements ITaskService {

  @override
  Future<List<Task>> getUserTasks(int userId) async {
    List<Task> _tasks = [_newTask(TaskType.geschiedenis, 120),
      _newTask(TaskType.techniek, 120),
      _newTask(TaskType.aardrijkskunde, 120), 
      _newTask(TaskType.nederlands, 60),
      _newTask(TaskType.rekenen, 60) ];
    return Future(() => _tasks);
  }

  static int index = 1;
  Task _newTask(TaskType tasktyp, int expeffInitial) {
    return Task(index++, index++, tasktyp, expeffInitial);
  }
}