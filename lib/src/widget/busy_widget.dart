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

class BusyTaskWidget extends StatefulWidget {
  @override
  _BusyTaskWidgetState createState() => _BusyTaskWidgetState();
}

class _BusyTaskWidgetState extends State<BusyTaskWidget>
    with SingleTickerProviderStateMixin {
  Task _task = AppUtils.getBusyTask();
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
      _taskInfo(_task),
      WidgetUtils.divLine(10),
      Text('Hoe lang heb je nog nodig'),
      _theSlider(),
      RaisedButton(
        child: const Text('Sluit'),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        splashColor: Colors.blueGrey,
        onPressed: () {
          AppEvents.fireStopTask();
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
          style: TextStyle(fontSize: 10),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _swowElapsedAndGif() {
    return Row(
      children: <Widget>[
        WidgetUtils.huiswerkImage(),
        WidgetUtils.divSpace(10),
        DigitalClock(),
      ],
    );
  }

  Widget _theSlider() {
    return Slider(
      activeColor: Colors.indigoAccent,
      min: 0.0,
      max: _task.expEffort.ceilToDouble(),
      onChanged: (newRating) {
        setState(() => _sliderValue = newRating);
      },
      value: _sliderValue,
    );
  }
}
