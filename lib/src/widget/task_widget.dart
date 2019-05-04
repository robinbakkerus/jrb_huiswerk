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
      childWhenDragging: Text(Constants.taskInfoMap[taskType]),
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
    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return _theSchedTaskWidget(task, date);
      },
      onWillAccept: (data) {
        return !AppData().isBusy && task.status == TaskStatusType.scheduled;
      },
      onAccept: (data) {
        print('todo accepted');
        AppEvents.fireStartTask(task);
      },
    );
  }

  static Widget _theSchedTaskWidget(Task task, DateTime date) {
    //kijk van rechts naar links wat  voor task we moeten plaatsen
    if (AppUtils.isAfterDueDate(task, date)) {
      return Container();
    } else if (AppUtils.isDueDate(task, date)) {
      if (task.isDone) {
        return _finishedTaskWidget(task, date);
      } else {
        return _wipTaskWidget(task, date);
      }
    } else {
      if (task.isDone) {
        return Container();
      } else {
        return _wipTaskWidget(task, date);
      }
    }
  }

  static Widget _finishedTaskWidget(Task task, DateTime date) {
    return Stack(
      children: <Widget>[_schedTaskImage(task, date), _isDoneImage()],
    );
  }

  static Widget _wipTaskWidget(Task task, DateTime date) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _schedTaskImage(task, date),
          WidgetUtils.divLine(3),
          _todoTime(task, date),
        ],
      ),
    );
  }

  static Widget _schedTaskImage(Task task, DateTime date) {
    double w = AppUtils.dayPct(task, date) * Constants.taskWidth();
    String imgname = AppUtils.schedImageName(task, date);

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

  static Widget _isDoneImage() {
    double w = Constants.taskWidth();

    return Container(
      width: w - 15,
      height: w - 15,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('images/done.png'),
          fit: BoxFit.fill,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.7), BlendMode.dstATop),
        ),
      ),
    );
  }

  static Widget taskImage(Task task) {
    double w = Constants.taskWidth();
    String imgname = AppUtils.imageName(task);

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
    double totalWidth = AppUtils.calcEffort(task, date);
    double doneWidth = AppUtils.calcEffDone(task, date);
    double todoWidth = totalWidth - doneWidth;
    doneWidth -= 4;
    todoWidth -= 4;
    if (doneWidth < 2.0) doneWidth = 1.0;
    if (todoWidth < 2.0) todoWidth = 1.0;

    // print("$w1  $w2  $w3");

    return Container(
        height: 8,
        width: totalWidth,
        decoration: new BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 5,
              width: todoWidth,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            Container(
              height: 4,
              width: doneWidth,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
