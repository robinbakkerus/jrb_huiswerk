import 'package:flutter/material.dart';

// import '../data/app_data.dart';
import '../data/constants.dart';
import '../model/task.dart';
import '../model/drag_data.dart';

class TaskWidget {
  static Container buildAllNewTaskWidgets(List<Task> newTasks) {
    return Container(
      height: Constants.taskHeight,
      width: 250,
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
      width: Constants.taskWidth,
      height: Constants.taskHeight,
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
              ))
        ],
      ),
    );
  }

  static Widget buildScheduledTaskWidget(Task task) {
    return Container(
      width: Constants.taskWidth,
      height: Constants.taskHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Constants.taskWidth,
            height: Constants.taskHeight,
            decoration: new BoxDecoration(
              // border: Border.all(color: Colors.black, width: 2),
              image: DecorationImage(
                image: new AssetImage(
                    'images/' + Constants.taskImageMap[task.type]),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              height: 5,
              decoration: new BoxDecoration(
                border: Border.all(color: Colors.green),
              ))
        ],
      ),
    );
  }
}
