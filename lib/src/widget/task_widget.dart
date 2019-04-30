import 'package:flutter/material.dart';

// import '../data/app_data.dart';
import '../data/constants.dart';
import '../model/task.dart';
import '../model/drag_data.dart';
import '../util/app_utils.dart';
import '../data/app_data.dart';
import '../events/app_events.dart';
import '../widget/widget_utils.dart';

class TaskWidget {
  static Container buildAllNewTaskWidgets(List<Task> newTasks) {
    return Container(
      height: Constants.taskHeight(),
      width: newTasks.length * Constants.taskWidth(),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newTasks.length,
          itemBuilder: (context, index) {
            return _newDragableTaskWidget(newTasks[index]);
          }),
    );
  }

  static Widget _newDragableTaskWidget(Task task) {
    TaskType taskType = task.type;
    return Draggable(
      data: DragData(DragType.newTask, task.id),
      child: _newTaskWidget(taskType),
      feedback: _newTaskWidget(taskType),
      childWhenDragging: Text(taskType.toString()),
    );
  }

  static Widget _newTaskWidget(TaskType taskType) {
    return Container(
      width: Constants.taskWidth(),
      height: Constants.taskHeight(),
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.green),
        image: DecorationImage(
          image: new AssetImage('images/' + Constants.taskImageMap[taskType]),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 3,
            decoration: new BoxDecoration(
              border: Border.all(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildScheduledTaskWidget(Task task, DateTime date) {
    bool accepted = true;
    bool startTask = !AppData().isBusy;

    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return accepted ? _buildSchedTaskDragTarget(task, date) : Container();
      },
      onWillAccept: (data) {
        return AppUtils.isToday(date);
      },
      onAccept: (data) {
        accepted = true;
        AppEvents.fireStartStopTask(task.id, startTask);
      },
    );
  }

  static Widget _buildSchedTaskDragTarget(Task task, DateTime date) {
    bool isDueDate = AppUtils.isDueDate(task, date);

    return Container(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _schedTask(task, date),
          WidgetUtils.divLine(3),
          _todoTime(task, date),
        ],
      ),
    );
  }

  static Widget _schedTask(Task task, DateTime date) {
    double w = AppUtils.dayPct(task, date) * Constants.taskWidth();
    String imgname = AppUtils.imageName(task, date);

    return Container(
      width: w,
      height: w,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        image: DecorationImage(
          image: new AssetImage('images/' + imgname),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  static Widget _todoTime(Task task, DateTime date) {
    double w1 = AppUtils.calcEffort(task, date);
    double w2 = AppUtils.calcEffDone(task, date);
    double w3 = w1 - w2;
    print("$w1  $w2  $w3");

    return Container(
        height: 8,
        width: w1,
        decoration: new BoxDecoration(
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 3,
              width: w2 - 2,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            w3 >= 1.0 ? Container(
              height: 3,
              width: w3 - 2,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ) : 
            Container()
          ],
        ));
  }

}
