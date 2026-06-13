import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isThrottling = false;

  Throttler({required this.delay});

  void call(void Function() action) {
    if (_isThrottling) return;
    action();
    _isThrottling = true;
    _timer = Timer(delay, () {
      _isThrottling = false;
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isThrottling = false;
  }
}
