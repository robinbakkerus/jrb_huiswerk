import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// import '../data/constants.dart';
import '../model/task.dart';
import 'task_widget.dart';
import '../data/app_data.dart';
import '../util/app_utils.dart';
import '../events/app_events.dart';
import '../model/drag_data.dart';
import 'widget_utils.dart';
import 'digital_clock.dart';

class BusyTaskWidget extends StatefulWidget {
  @override
  _BusyTaskWidgetState createState() => _BusyTaskWidgetState();
}

class _BusyTaskWidgetState extends State<BusyTaskWidget>
    with SingleTickerProviderStateMixin {
  Task _task = AppUtils.getBusyTask();
  Animation<double> _animation;
  AnimationController _animCtrl;
  double _sliderValue;

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 240).animate(_animCtrl)
      ..addListener(() {
        setState(() {});
      });
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      builder: (context, List<DragData> candidateData, rejectedData) {
        return _theBusyWidget();
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {
        print("todo 1");
        AppEvents.fireAskTaskProgress();
      },
    );
  }

  Widget _theBusyWidget() {
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
        child: _columnWidgets(),
      ),
    );
  }

  Widget _columnWidgets() {
    if (_animation.value < 200) {
      return null;
    } else if (AppData().isBusy) {
      return Column(children: _whileBusyWidgets());
    } else {
      return Column(children: _askForProgressWidgets());
    }
  }

  List<Widget> _whileBusyWidgets() {
    return [
      _taskInfo(_task),
      WidgetUtils.divLine(10),
      _swowElapsedAndGif(),
      WidgetUtils.divLine(10),
      Text('Sleep de stopwatch hier naar toe als je klaar bent'),
    ];
  }

  List<Widget> _askForProgressWidgets() {
    return [
      // _taskInfo(_task),
      // WidgetUtils.divLine(10),
      Text(
        'Hoe lang heb je nog nodig ?\n 0 is klaar!',
        textAlign: TextAlign.left,
        // style: TextStyle(fontSize: 10),
        maxLines: 3,
      ),
      WidgetUtils.divLine(10),
      _theSlider(),
      _theSlid2erFooter(),
      WidgetUtils.divLine(10),
      RaisedButton(
        child: const Text('Sluit'),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        splashColor: Colors.blueGrey,
        onPressed: () {
          _task.expEffort = _sliderValue.floor();
          AppEvents.fireStopTask(_task);
        },
      ),
    ];
  }

  Widget _taskInfo(Task task) {
    // if (task == null) return Text('???');

    return Row(
      children: <Widget>[
        TaskWidget.taskImage(task),
        WidgetUtils.divSpace(10),
        Text(
          task.infoMsg(),
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 12),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _swowElapsedAndGif() {
    return Row(
      children: <Widget>[
        WidgetUtils.huiswerkImage(),
        WidgetUtils.divSpace(5),
        DigitalClock(),
        WidgetUtils.divSpace(5),
        Text('van ' + _task.todoPerDay().toString()),
      ],
    );
  }

  Widget _theSlid2erFooter() {
    return Row(
      children: <Widget>[
        WidgetUtils.divSpace(10),
        Text('0'),
        WidgetUtils.divSpace(50),
        Text(_sliderValue.ceil().toString()),
        WidgetUtils.divSpace(50),
        Text((_task.expEffort * 2.0).ceil().toString()),
      ],
    );
  }

  Widget _theSlider() {
    int expeff = _task.expEffort;
    int spend = _task.timeSpend;
    int todo = max(0, expeff - spend);
    print("todo = $todo");
    if (_sliderValue == null) _sliderValue = todo.ceilToDouble();

    return Row(
      children: <Widget>[
        Slider(
          value: _sliderValue,
          // label: todo.toString(),
          activeColor: Colors.indigoAccent,
          min: 0.0,
          max: _task.expEffort.ceilToDouble() * 2.0,
          onChanged: (newRating) {
            setState(() => _sliderValue = newRating);
            print(newRating);
          },
        ),
      ],
    );
  }
}
