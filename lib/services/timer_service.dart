import 'dart:async';

class TimerService {
  static final TimerService _instance = TimerService._internal();

  factory TimerService() {
    return _instance;
  }

  TimerService._internal();

  Timer? _timer;
  int _seconds = 0;

  void startTimer(Function(int) callback) {
    stopTimer();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _seconds += 10;
      callback(_seconds);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _seconds = 0;
  }

  int getSeconds() => _seconds;
}
