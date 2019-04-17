import '../model/task.dart';
import 'task_srv_mock_impl.dart';
// import '../data/app_data.dart';

abstract class ITaskService {

  Future<List<Task>> getUserTasks(int userId) async {return null;}

  
  factory ITaskService() {
    return TaskServiceMockImpl();
  }
}