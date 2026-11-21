import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/utils/debouncer.dart';

void main() {
  group('Debouncer & Throttler Unit Tests', () {
    test('Debouncer cancels preceding calls and executes only the last one', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 50));
      int callCount = 0;
      String lastValue = '';

      debouncer(() {
        callCount++;
        lastValue = 'first';
      });

      debouncer(() {
        callCount++;
        lastValue = 'second';
      });

      debouncer(() {
        callCount++;
        lastValue = 'third';
      });

      expect(callCount, equals(0));

      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(callCount, equals(1));
      expect(lastValue, equals('third'));

      debouncer.dispose();
    });

    test('Throttler executes immediately then ignores subsequent triggers within interval', () async {
      final throttler = Throttler(delay: const Duration(milliseconds: 60));
      int executedCount = 0;

      throttler(() => executedCount++);
      throttler(() => executedCount++);
      throttler(() => executedCount++);

      // Immediately executed once
      expect(executedCount, equals(1));

      // After delay, should accept next call
      await Future<void>.delayed(const Duration(milliseconds: 80));

      throttler(() => executedCount++);
      expect(executedCount, equals(2));

      throttler.dispose();
    });
  });
}
