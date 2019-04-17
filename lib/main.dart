import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/widget/home_page.dart';
import 'src/ctrl/app_ctrl.dart';
// import 'src/data/app_data.dart';

void main() {
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft])
      .then((_) => runApp(new App()));
}

class App extends StatelessWidget {
  App() {
    AppController();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Italiaans APP',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new StartPage(),
    );
  }
}
