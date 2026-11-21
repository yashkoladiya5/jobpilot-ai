import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';

void main() {
  group('JobAnalysis Entity Tests', () {
    test('JobAnalysis.fromJson parses valid complete payload', () {
      final json = {
        'id': 'ja-101',
        'jobId': 'job-55',
        'jobTitle': 'Senior Staff Engineer',
        'jobDescription': 'We are looking for an experienced software leader with Flutter experience.',
        'analyzedAt': '2026-11-20T14:30:00.000Z',
        'requiredSkills': ['Flutter', 'Dart', 'GraphQL'],
        'preferredSkills': ['CI/CD', 'Firebase'],
        'experienceRequired': '5+ years',
        'missingSkills': ['GraphQL'],
        'resumeMatchScore': 87.5,
        'recommendedChanges': [
          'Highlight Flutter architectural experience',
          'Mention GraphQL query optimization'
        ],
      };

      final analysis = JobAnalysis.fromJson(json);

      expect(analysis.id, equals('ja-101'));
      expect(analysis.jobId, equals('job-55'));
      expect(analysis.jobTitle, equals('Senior Staff Engineer'));
      expect(analysis.matchScore, equals(87.5));
      expect(analysis.experienceRequired, equals('5+ years'));
      expect(analysis.requiredSkills, containsAll(['Flutter', 'Dart', 'GraphQL']));
      expect(analysis.preferredSkills, containsAll(['CI/CD', 'Firebase']));
      expect(analysis.missingSkills, contains('GraphQL'));
      expect(analysis.recommendations.length, equals(2));
    });

    test('JobAnalysis.fromJson defaults null resumeMatchScore and null recommendations', () {
      final json = {
        'id': 'ja-102',
        'jobDescription': 'General Developer opening.',
        'analyzedAt': '2026-11-21T08:00:00.000Z',
        'requiredSkills': ['Python'],
        'preferredSkills': <String>[],
        'experienceRequired': '2 years',
        'missingSkills': <String>[],
        'resumeMatchScore': null,
        'recommendedChanges': null,
      };

      final analysis = JobAnalysis.fromJson(json);

      expect(analysis.id, equals('ja-102'));
      expect(analysis.jobId, isNull);
      expect(analysis.jobTitle, isNull);
      expect(analysis.matchScore, equals(0.0));
      expect(analysis.recommendations, isEmpty);
    });
  });
}
