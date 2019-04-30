import 'package:flutter/material.dart';

import '../data/app_data.dart';

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

}