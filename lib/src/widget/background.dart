import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../model/task.dart';
import 'task_widget.dart';
import '../data/constants.dart';
import '../util/app_utils.dart';
import '../events/app_events.dart';
import '../model/drag_data.dart';

class Background {
  static Widget backWidgets(List<Task> tasks) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
      width: AppData().screenWidth - 10,
      height: AppData().screenHeight - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _topRow(tasks),
          Divider(
            height: 2,
          ),
          _scheduledTasks(tasks),
        ],
      ),
    );
  }

  static Widget _topRow(List<Task> tasks) {
    return Container(
      decoration: new BoxDecoration(border: new Border.all(color: Colors.blue)),
      width: AppData().screenWidth * 0.9,
      height: Constants.taskHeight,
      child: Row(
        children: <Widget>[
          _newTasks(tasks),
          _divSpace(10),
          _stopWatch(),
        ],
      ),
    );
  }

  static Widget _newTasks(List<Task> tasks) =>
      TaskWidget.buildAllNewTaskWidgets(AppUtils.newTasks(tasks));

  static Widget _stopWatch() {
  return Container(
      width: Constants.taskWidth,
      height: Constants.taskHeight,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.green),
        image: DecorationImage(
          image: new AssetImage('images/stopwatch.png'),
          fit: BoxFit.fill,
        ),
      ),
      
    );
  }

  static Widget _scheduledTasks(List<Task> tasks) {
    List<DateTime> caldays = AppUtils.calDays();
    return Container(
      height: _dayHeight(),
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

  static Widget _schedTasksPerDay(List<Task> tasks, DateTime date) {
    return Container(
      decoration:
          new BoxDecoration(border: new Border.all(color: Colors.blueGrey)),
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.all(1.0),
      // width: _dayWidth(),
      height: _dayHeight(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _theScheduledTasks(tasks, date),
      ),
    );
  }

  static List<Widget> _theScheduledTasks(List<Task> tasks, DateTime date) {
    List<Task> _schedTasks =
        AppUtils.scheduledTasks(tasks, AppUtils.yearDayFromDate(date));
    AppUtils.sortTasks(_schedTasks);

    List<Widget> r = List();
    r.add(_taskDayHeader(date));
    r.add(_divLine());

    for (int i = 0; i < _schedTasks.length; i++) {
      r.add(Container(
        width: Constants.taskWidth,
        height: Constants.taskHeight + 12,
        child: TaskWidget.buildScheduledTaskWidget(_schedTasks[i]),
      ));
    }

    r.add(_divLine());
    return r;
  }

  static Widget _taskDayHeader(DateTime date) {
    String hdr = AppUtils.dayHdr(date);
    bool accepted = false;
    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return Container(
          height: Constants.taskHeight,
          width: Constants.taskWidth,
          decoration: BoxDecoration(
              color: Colors.yellow,
              border: new Border.all(color: Colors.brown, width: 2)),
          child: Text(hdr),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        DragData _dragData = data as DragData;
        AppEvents.fireScheduleTasks(_dragData.taskId, date);
        accepted = true;
      },
      onLeave: (data) {
        print('onleave');
      },
    );
  }

  static Widget _divLine() => Divider(
        height: 5,
        color: Colors.amber,
      );

  static Widget _divSpace(double w) {
    return Container(
      width: w,
      color: Colors.amber,
      );
  }

  // static double _dayWidth() => (AppData().screenWidth - 100) / 7.0;
  static double _dayHeight() => (AppData().screenHeight * 0.7);
}
