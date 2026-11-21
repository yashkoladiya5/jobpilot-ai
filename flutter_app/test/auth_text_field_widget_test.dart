import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/presentation/widgets/auth_text_field.dart';

void main() {
  testWidgets('AuthTextField renders label, hint, prefixIcon and text editing works',
      (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthTextField(
            controller: controller,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email,
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    expect(controller.text, equals('test@example.com'));
  });

  testWidgets('AuthTextField renders obscureText and suffix toggle',
      (tester) async {
    final controller = TextEditingController(text: 'secret123');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthTextField(
            controller: controller,
            label: 'Password',
            hint: 'Enter password',
            obscureText: true,
            suffixIcon: const Icon(Icons.visibility),
          ),
        ),
      ),
    );

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.obscureText, isTrue);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });
}
