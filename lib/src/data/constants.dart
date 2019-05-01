import '../model/settings.dart';

class Constants {
  static Settings current = new Settings("");
  static double taskWidth() => 55.0;
  static double taskHeight() => 55.0;
  static double schedTaskHeight()  => 55.0 + 15;
  static bool devMode = true;
  static Duration useDuration = devMode ? Duration(seconds: 1) : Duration(minutes: 1);

  static var taskImageMap = {
    TaskType.geschiedenis : 'geschiedenis.png',
    TaskType.nederlands : 'taal.png',
    TaskType.rekenen : 'rekenen.png',
    TaskType.aardrijkskunde : 'aardrijkskunde.png',
    TaskType.techniek : 'techniek.png',
  };

  static var taskInfoMap = {
    TaskType.geschiedenis : 'Geschiedenis',
    TaskType.nederlands : 'Nederlands',
    TaskType.rekenen : 'Rekenen',
    TaskType.aardrijkskunde : 'Aardrijkskunde',
    TaskType.techniek : 'Techniek',
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

  static var maand = ["Jan", "Feb", "Maart", "April", "Mei", "Juni", "Juli", "Aug", "Sep", "Okt", "Nov", "Dec"];
}

enum TaskType {
  rekenen, nederlands, geschiedenis, techniek, aardrijkskunde
}

enum TaskStatus {
  newtask, scheduled, busy, done, 
}

enum DragType {
  newTask, start, stop,
}
