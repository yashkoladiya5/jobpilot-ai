import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';

void main() {
  testWidgets('ErrorDisplay renders message and retry button when onRetry provided',
      (tester) async {
    bool retryPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorDisplay(
            message: 'Failed to connect to server',
            onRetry: () {
              retryPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Failed to connect to server'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    expect(retryPressed, isTrue);
  });

  testWidgets('ErrorDisplay renders without retry button when onRetry is null',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ErrorDisplay(
            message: 'Unauthorized access',
            icon: Icons.lock_outline,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Unauthorized access'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
