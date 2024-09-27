part of 'enter.dart';

class Throttle {
  static Map<String, Timer?> timerMap = {};
  late final Duration duration;
  Timer? _timer;

  Throttle({Duration? duration}) {
    this.duration = duration ?? Duration(seconds: 2);
  }

  void call(String key, void Function() action) {
    if (timerMap[key]?.isActive ?? false) return;
    timerMap[key] = Timer(duration, () {
      _timer = null;
    });
    action();
  }

  void dispose() {
    _timer?.cancel();
  }
}
