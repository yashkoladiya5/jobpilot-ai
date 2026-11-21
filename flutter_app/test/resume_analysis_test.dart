import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';

void main() {
  group('ResumeAnalysis Entity Tests', () {
    test('ResumeAnalysis.fromJson parses full ATS analysis payload', () {
      final json = {
        'id': 'ra-200',
        'resumeId': 'res-10',
        'resumeFileName': 'Senior_Mobile_Engineer.pdf',
        'atsScore': 88,
        'strengths': ['Action verbs lead every bullet', 'Clear quantifiable metrics'],
        'weaknesses': ['Missing explicit mentions of CI/CD pipelines'],
        'missingKeywords': ['Docker', 'Kubernetes', 'GitHub Actions'],
        'suggestions': ['Include automation pipeline achievements'],
        'experienceSummary': '7+ years leading cross-platform mobile teams.',
        'skillsSummary': 'Flutter, Dart, TypeScript, Node.js, GraphQL.',
        'recruiterFeedback': 'Resume looks sharp, highly competitive for lead-level roles.',
        'createdAt': '2026-11-20T15:00:00.000Z',
      };

      final analysis = ResumeAnalysis.fromJson(json);

      expect(analysis.id, equals('ra-200'));
      expect(analysis.resumeFileName, equals('Senior_Mobile_Engineer.pdf'));
      expect(analysis.atsScore, equals(88));
      expect(analysis.isExcellentScore, isTrue);
      expect(analysis.strengths.length, equals(2));
      expect(analysis.missingKeywords, contains('GitHub Actions'));
      expect(analysis.recruiterFeedback, contains('highly competitive'));
    });

    test('ResumeAnalysis falls back to nested resume fileName and evaluates isExcellentScore correctly', () {
      final json = {
        'id': 'ra-201',
        'resumeId': 'res-11',
        'resume': {
          'fileName': 'Nested_Resume_Name.docx',
        },
        'atsScore': 68,
        'strengths': <String>['Clean layout'],
        'weaknesses': <String>['Short descriptions'],
        'missingKeywords': <String>['Dart'],
        'suggestions': <String>['Elaborate on project scope'],
        'experienceSummary': 'Mid-level developer.',
        'skillsSummary': 'Flutter.',
        'recruiterFeedback': 'Needs more metrics.',
        'createdAt': '2026-11-21T06:00:00.000Z',
      };

      final analysis = ResumeAnalysis.fromJson(json);

      expect(analysis.resumeFileName, equals('Nested_Resume_Name.docx'));
      expect(analysis.atsScore, equals(68));
      expect(analysis.isExcellentScore, isFalse);
    });
  });
}
