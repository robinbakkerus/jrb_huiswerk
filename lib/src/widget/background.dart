import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../model/task.dart';
import 'task_widget.dart';
import '../data/constants.dart';
import '../util/app_utils.dart';
import '../events/app_events.dart';
import '../model/drag_data.dart';
import 'widget_utils.dart';
import 'busy_widget.dart';

class Background {

  static Widget backWidgets(List<Task> tasks) {
    return Stack(
      children: <Widget>[
        Container(
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
        ),
        _getInfoWidget(),
      ],
    );
  }

  static Widget _getInfoWidget() {
    if (AppData().isBusy) {
      return BusyTaskWidget();
    } else if (AppData().isWaiting) {
      return BusyTaskWidget();
    }
    return Container();
  }

  static Widget _topRow(List<Task> tasks) {
    return Container(
      decoration: new BoxDecoration(border: new Border.all(color: Colors.blue)),
      width: 50 + (AppData().tasks.length + 2) * Constants.taskWidth() ,
      height: Constants.taskHeight(),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _newTasks(tasks),
          WidgetUtils.divSpace(5),
          _dragableStartStopWatchStart(),
          WidgetUtils.divSpace(2),
          _dragableStartStopWatchStop(),
        ],
      ),
    );
  }

  static Widget _newTasks(List<Task> tasks) =>
      TaskWidget.buildAllNewTaskWidgets(AppUtils.newTasks(tasks));

  static Widget _stopWatch(String image, bool active) {
    return Container(
      width: Constants.taskWidth(),
      height: Constants.taskHeight(),
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.green),
        image: DecorationImage(
          image: new AssetImage('images/' + image),
          fit: BoxFit.fill,
          colorFilter: active
              ? null
              : new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
    );
  }

  static Widget _dragableStartStopWatchStart() {
    return AppData().isBusy
        ? _stopWatch('stopwatch_start.png', false)
        : Draggable(
            data: DragData(DragType.start, -1),
            child: _stopWatch('stopwatch_start.png', true),
            feedback: _stopWatch('stopwatch_start.png', true),
            childWhenDragging: Text("..."),
          );
  }

  static Widget _dragableStartStopWatchStop() {
    return AppData().isBusy
        ? Draggable(
            data: DragData(DragType.stop, -1),
            child: _stopWatch('stopwatch_stop.png', true),
            feedback: _stopWatch('stopwatch_stop.png', true),
            childWhenDragging: Text("..."),
          )
        : _stopWatch('stopwatch_stop.png', false);
  }

  static Widget _scheduledTasks(List<Task> tasks) {
    List<DateTime> caldays = AppUtils.calendarDays();
    return Container(
      height: WidgetUtils.dayHeight(),
      width: WidgetUtils.tasksWidth(),
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
      height: WidgetUtils.dayHeight(),
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
    r.add(WidgetUtils.divLine(3));

    for (int i = 0; i < _schedTasks.length; i++) {
      r.add(Container(
        width: Constants.taskWidth(),
        height: Constants.schedTaskHeight(),
        child: TaskWidget.buildScheduledTaskWidget(_schedTasks[i], date),
      ));
    }
    return r;
  }

  static Widget _taskDayHeader(DateTime date) {
    String hdr = AppUtils.dayHdr(date);
    // bool accepted = false;
    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return Container(
          height: 40, //Constants.taskHeight(),
          width: Constants.taskWidth(),
          decoration: BoxDecoration(
              color: Colors.yellow,
              border: new Border.all(color: Colors.brown, width: 2)),
          child: Text(hdr, 
           textAlign: TextAlign.justify,
          // style: TextStyle(fontSize: 10),
          maxLines: 2,),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        print("todo 2");
        DragData _dragData = data as DragData;
        AppEvents.fireScheduleTasks(_dragData.taskId, date);
        // accepted = true;
      },
    );
  }
}
