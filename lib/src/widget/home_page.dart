import 'package:flutter/material.dart';

import '../model/task.dart';
// import 'task_widget.dart';
import '../data/app_data.dart';
import '../events/app_events.dart';
import '../widget/background.dart';
// import '../util/app_utils.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Huiswerk APP',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new _HomePage(
        title: 'Huiswerk App',
        context: context,
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  _HomePage({Key key, this.title, this.context}) : super(key: key) {
    AppData().screenWidth = MediaQuery.of(context).size.width;
    AppData().screenHeight = MediaQuery.of(context).size.height;
  }

  final String title;
  final BuildContext context;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  // String _image;
  List<Task> _tasks;
  AppData _appData;

  _HomePageState() {
    _appData = AppData();
    AppEvents.onTaskReady(_onTaskReady);
    AppEvents.fireGetTasks();
  }

  void _onTaskReady(TasksReadyEvent event) {
    setState(() {
      _tasks = _appData.tasks;
    });
  }

  @override
  void initState() {
    super.initState();
    // _image = 'images/' + "huiswerk" + ".jpg";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: buildMainAppBar(context, -1),
      // body: Stack(children: <Widget>[
      //   Background.backWidgets(_tasks),
      // ]),
      body : _tasks != null ? Background.backWidgets(_tasks) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _refresh() {
   setState(() {
      _tasks = List();
    });
    AppEvents.fireGetTasks();
  }
}
