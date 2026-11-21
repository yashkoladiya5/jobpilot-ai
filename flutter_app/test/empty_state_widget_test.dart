import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState displays icon, message, subtitle, and executes action',
      (tester) async {
    bool actionCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.inbox,
            message: 'No items found',
            subtitle: 'Start by creating your first item',
            actionLabel: 'Add Item',
            onAction: () {
              actionCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('No items found'), findsOneWidget);
    expect(find.text('Start by creating your first item'), findsOneWidget);
    expect(find.text('Add Item'), findsOneWidget);

    await tester.tap(find.text('Add Item'));
    await tester.pump();

    expect(actionCalled, isTrue);
  });

  testWidgets('EmptyState renders cleanly without subtitle and action button',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.search_off,
            message: 'No results found',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.search_off), findsOneWidget);
    expect(find.text('No results found'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
