import 'dart:async';
import 'dart:ui';

class Throttler {
  final Duration duration;
  Timer? _timer;
  bool _shouldRun = true;

  Throttler({required this.duration});

  void run(VoidCallback action) {
    if (_shouldRun) {
      action();
      _shouldRun = false;
      _timer = Timer(duration, () => _shouldRun = true);
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
