import 'dart:async';

import '../data/constants.dart';
import '../events/app_events.dart';

class TimerService {
  Stopwatch _watch;
  Timer _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  int _elapsedTime = 0;

  bool get isRunning => _timer != null;

  TimerService() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;
    _elapsedTime += 1;
    if (_timer != null) {
      AppEvents.fireTick(_elapsedTime);
    }
  }

  void start() {
    if (_timer != null) return;

    _elapsedTime = 0;
    _timer = Timer.periodic(Constants.useDuration, _onTick);
    _watch.start();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;
  }

  void reset() {
    stop();
    _watch.reset();
    _currentDuration = Duration.zero;
  }

  int get elapsedTime => _elapsedTime;
  
}


