import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/presentation/widgets/stats_card.dart';

void main() {
  testWidgets('StatsCard displays label, number, and icon with theme styling',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatsCard(
            icon: Icons.work,
            iconBackgroundColor: Colors.blue,
            number: '42',
            label: 'Total Applications',
            tooltipMessage: 'Applications submitted',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.work), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Total Applications'), findsOneWidget);
    expect(find.byType(Tooltip), findsOneWidget);
  });

  testWidgets('StatsCard displays optional trailingIcon widget',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatsCard(
            icon: Icons.trending_up,
            iconBackgroundColor: Colors.green,
            number: '12%',
            label: 'Conversion Rate',
            trailingIcon: Icon(Icons.arrow_upward, key: Key('trending-up-icon')),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.trending_up), findsOneWidget);
    expect(find.text('12%'), findsOneWidget);
    expect(find.byKey(const Key('trending-up-icon')), findsOneWidget);
  });
}
