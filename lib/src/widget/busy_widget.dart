import 'package:flutter/material.dart';

// import '../data/app_data.dart';
import '../model/task.dart';
import 'task_widget.dart';
// import '../data/constants.dart';
import '../util/app_utils.dart';
import '../events/app_events.dart';
import '../model/drag_data.dart';
import 'widget_utils.dart';

class BusyWidget {
  static Widget loadBusyWidget() {
    Task task = AppUtils.getBusyTask();

    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return _busyWidget(task);
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        AppEvents.fireStopTask();
      },
    );
  }

  static Widget _busyWidget(Task task) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blueGrey,
              width: 3,
            ),
            color: Colors.lightGreenAccent),
        width: 200,
        height: 210,
        child: Column(
          children: <Widget>[
            _taskInfo(task),
            WidgetUtils.divLine(10),
            _swowElapsedAndGif(),
            WidgetUtils.divLine(10),
            Text('Sleep de stopwatch hier naar toe als je klaar bent'),
          ],
        ),
      ),
    );
  }

  static Widget _taskInfo(Task task) {
    // if (task == null) return Text('???');

    return Row(
      children: <Widget>[
        TaskWidget.taskImage(task),
        WidgetUtils.divSpace(10),
        Text(
          task.infoMsg(),
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 10),
          maxLines: 4,
        ),
      ],
    );
  }

  static Widget _swowElapsedAndGif() {
    String s = "0";

    return Row(
      children: <Widget>[
        WidgetUtils.huiswerkImage(),
        WidgetUtils.divSpace(10),
        _ElapsedTimeWidget(),
      ],
    );
  }
}

class _ElapsedTimeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ElapsedTimeWidgetState();

}

class _ElapsedTimeWidgetState extends State<_ElapsedTimeWidget> {
 String s = "0";

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      AppEvents.onTick((event) {
        if (mounted) {
        setState(() {
          s = event.elapsed.toString();
        });

        }
      });
      return Text(s);
    });
  }
}

