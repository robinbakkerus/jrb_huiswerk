import '../data/app_data.dart';

class AppController {
  static final AppController _instance = new AppController.internal();
  factory AppController() => _instance;

  AppData _appData;
  
  AppController.internal() {
    _appData = AppData();
    print(_appData.toString());
  }
}