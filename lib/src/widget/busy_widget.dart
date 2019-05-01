import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../model/task.dart';
import 'task_widget.dart';
import '../data/app_data.dart';
import '../util/app_utils.dart';
import '../events/app_events.dart';
import '../model/drag_data.dart';
import 'widget_utils.dart';
import 'digital_clock.dart';

class BusyWidget {
  static Widget loadBusyWidget() {
    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        // return _busyWidget(task);
        return _TheBusyWidget();
      },
      onWillAccept: (data) {
        print("todo 1x");
        return true;
      },
      onAccept: (data) {
        print("todo 1");
        AppEvents.fireStopTask();
      },
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
    return Row(
      children: <Widget>[
        WidgetUtils.huiswerkImage(),
        WidgetUtils.divSpace(10),
        DigitalClock(),
      ],
    );
  }
}

//------------------
class _TheBusyWidget extends StatefulWidget {
  @override
  __TheBusyWidgetState createState() => __TheBusyWidgetState();
}

class __TheBusyWidgetState extends State<_TheBusyWidget>
    with SingleTickerProviderStateMixin {
  Task task = AppUtils.getBusyTask();
  Animation<double> _animation;
  AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 210).animate(_animCtrl)
      ..addListener(() {
        setState(() {});
      });
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blueGrey,
              width: 3,
            ),
            color: Colors.yellow),
        width: _animation.value,
        height: _animation.value,
        child: _animation.value < 200
            ? null
            : Column(
                children: <Widget>[
                  BusyWidget._taskInfo(task),
                  WidgetUtils.divLine(10),
                  BusyWidget._swowElapsedAndGif(),
                  WidgetUtils.divLine(10),
                  Text('Sleep de stopwatch hier naar toe als je klaar bent'),
                ],
              ),
      ),
    );
  }
}

//------------------
class AskProgressWidget extends StatefulWidget {
  @override
  _AskProgressWidgetState createState() => _AskProgressWidgetState();
}

class _AskProgressWidgetState extends State<AskProgressWidget>
    with SingleTickerProviderStateMixin {
  // Task task = AppUtils.getBusyTask();
  Animation<double> _animation;
  AnimationController _animCtrl;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 210).animate(_animCtrl)
      ..addListener(() {
        setState(() {});
      });
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            border: new Border.all(
              color: Colors.blueGrey,
              width: 3,
            ),
            color: Colors.yellow),
        width: _animation.value,
        height: _animation.value,
        child: _animation.value < 200
            ? null
            : Column(
                children: <Widget>[
                  Text('Hoe lang heb je nog nodig'),
                  Slider(
                    activeColor: Colors.indigoAccent,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (newRating) {
                      setState(() => _sliderValue = newRating);
                    },
                    value: _sliderValue,
                  ),
                  RaisedButton(
                    child: const Text('Sluit'),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      AppData().setStatus(AppStatusType.none);
                      AppEvents.fireGetTasks();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
