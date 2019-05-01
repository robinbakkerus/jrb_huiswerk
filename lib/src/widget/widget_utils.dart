import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../data/constants.dart';

class WidgetUtils {

   static Widget divLine(double h) => Divider(
        height: h,
        color: Colors.amber,
      );

  static Widget divSpace(double w) {
    return Container(
      width: w,
      color: Colors.amber,
    );
  }

  static double tasksWidth() => 600; //todo
  static double dayHeight() => (AppData().screenHeight * 0.8);

static Widget huiswerkImage() {
    double w = Constants.taskWidth();

    return Container(
      width: w,
      height: w,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        image: DecorationImage(
          image: new AssetImage('images/' + 'homework.gif'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }


}