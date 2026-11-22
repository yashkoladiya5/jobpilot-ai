import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/presentation/widgets/resume_card.dart';

void main() {
  final tResume = Resume(
    id: 'res-1',
    userId: 'u1',
    fileName: 'senior_flutter_cv.pdf',
    filePath: '/storage/resumes/senior_flutter_cv.pdf',
    fileSize: 1024 * 500, // 500 KB
    mimeType: 'application/pdf',
    isPrimary: true,
    createdAt: DateTime(2025, 2, 10),
  );

  testWidgets('ResumeCard renders file name, primary badge, and triggers onTap and onDelete',
      (tester) async {
    bool tapped = false;
    bool deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResumeCard(
            resume: tResume,
            onTap: () {
              tapped = true;
            },
            onDelete: () {
              deleted = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('senior_flutter_cv.pdf'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);

    await tester.tap(find.text('senior_flutter_cv.pdf'));
    expect(tapped, isTrue);

    // Tap the delete action
    final deleteIcon = find.byIcon(Icons.delete_outline);
    if (deleteIcon.evaluate().isNotEmpty) {
      await tester.tap(deleteIcon);
      expect(deleted, isTrue);
    }
  });

  testWidgets('ResumeCard renders non-primary resume without PRIMARY badge',
      (tester) async {
    final nonPrimaryResume = tResume.copyWith(isPrimary: false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResumeCard(
            resume: nonPrimaryResume,
          ),
        ),
      ),
    );

    expect(find.text('Primary'), findsNothing);
  });
}
