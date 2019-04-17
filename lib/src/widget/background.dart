import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../model/task.dart';
import 'task_widget.dart';
import '../data/constants.dart';
import '../util/app_utils.dart';

class Background {
  static Widget backWidgets(List<Task> tasks) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
      width: AppData().screenWidth - 10,
      height: AppData().screenHeight - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _newTasks(tasks),
          Divider(
            height: 2,
          ),
          _scheduledTasks(tasks),
        ],
      ),
    );
  }

  static Widget _newTasks(List<Task> tasks) {
    return Stack(
      children: <Widget>[
        Container(
          decoration:
              new BoxDecoration(border: new Border.all(color: Colors.blue)),
          width: AppData().screenWidth * 0.9,
          height: Constants.taskHeight,
          child: Text("..."),
        ),
        TaskWidget.buildAllNewTaskWidgets(AppUtils.newTasks(tasks)),
      ],
    );
  }

  static Widget _scheduledTasks(List<Task> tasks) {
    List<DateTime> caldays = AppUtils.calDays();
    return Container(
      height: 240,
      width: 600,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: caldays.length,
        itemBuilder: (context, index) {
          return _schedTasksPerDay(tasks, caldays[index]);
        },
      ),
    );
  }

  static Widget _dayHeader(String day) {
    return Container(
      width: Constants.taskWidth,
      height: 20,
      decoration: new BoxDecoration(
        // borderRadius: new BorderRadius.circular(3.0),
        color: Colors.yellow,
      ),
      // padding: EdgeInsets.all(5.0),
      child: Text(day),
    );
  }

  static Widget _schedTasksPerDay(List<Task> tasks, DateTime date) {
    return Container(
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.blueGrey)),
        padding: EdgeInsets.all(1.0),
        margin: EdgeInsets.all(1.0),
        // width: _dayWidth(),
        height: _dayHeight(),
        // color: Colors.yellow,
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _dayHeader(AppUtils.dayHdr(date)),
            // _divLine(),
            _theScheduledTasks(tasks),
            // _divLine(),
            _taskSlot(),
          ],
        ),
      );
  }

  static Widget _theScheduledTasks(List<Task> tasks) {
    List<Task> _schedTasks =
        AppUtils.scheduledTasks(tasks, AppUtils.yearDayFromNow());
    return Container(
      width: Constants.taskWidth,
      height: Constants.taskHeight * (1+_schedTasks.length),
      child: ListView.builder(
          itemCount: _schedTasks.length,
          itemBuilder: (context, index) {
            return TaskWidget.buildTaskWidget(tasks[index]);
          }),
    );
  }

  static Widget _taskSlot() {
    return DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            print(candidateData);
            return Container(
              height:Constants.taskHeight ,
              width: Constants.taskWidth,
              decoration:
                  BoxDecoration(border: new Border.all(color: Colors.orange)),
            );
          },
          onWillAccept: (data) {
            print("todo");
            return true;
          },
          onAccept: (data) {
            print("todo accept");
          },
        );
  }

  static Widget _divLine() => Divider(
        height: 5,
        color: Colors.amber,
      );
  // static double _dayWidth() => (AppData().screenWidth - 100) / 7.0;
  static double _dayHeight() => (AppData().screenHeight * 0.7);
}
