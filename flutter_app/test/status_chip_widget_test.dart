import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';

void main() {
  group('StatusChip Widget Tests', () {
    testWidgets('renders correct label for ApplicationStatus.applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusChip(status: ApplicationStatus.applied),
          ),
        ),
      );

      expect(find.text('Applied'), findsOneWidget);
    });

    testWidgets('renders correct label for ApplicationStatus.interview', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusChip(status: ApplicationStatus.interview),
          ),
        ),
      );

      expect(find.text('Interview'), findsOneWidget);
    });

    testWidgets('renders correct label for ApplicationStatus.offer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusChip(status: ApplicationStatus.offer),
          ),
        ),
      );

      expect(find.text('Offer'), findsOneWidget);
    });
  });
}
