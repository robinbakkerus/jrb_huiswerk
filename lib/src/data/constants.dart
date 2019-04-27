import '../model/settings.dart';

class Constants {
  static Settings current = new Settings("");
  static double taskWidth = 55.0;
  static double taskHeight = 55.0;

  static var taskImageMap = {
    TaskType.geschiedenis : 'geschiedenis.png',
    TaskType.nederlands : 'taal.png',
    TaskType.rekenen : 'rekenen.png'
  };

  static var dayHeaders = {
    1 : "Maa", 
    2 : "Din",
    3 : "Woe",
    4 : "Don",
    5 : "Vry",
    6 : "Zat",
    7 : "Zon"
  };
}

enum TaskType {
  rekenen, nederlands, geschiedenis
}

enum TaskStatus {
  newtask, scheduled, busy, done, 
}

enum DragType {
  newTask, start, stop,
}
