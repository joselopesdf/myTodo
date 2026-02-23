import 'dart:async';
import 'dart:ui';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  void run(VoidCallback action) {
    _timer?.cancel(); // cancela chamadas anteriores

    _timer = Timer(duration, () {
      action(); // roda só quando parar
    });
  }
}
