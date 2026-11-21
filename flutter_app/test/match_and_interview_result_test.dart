import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/match_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';

void main() {
  group('MatchResult Entity Tests', () {
    test('MatchResult.fromJson accurately parses match payloads', () {
      final json = {
        'matchScore': 92.5,
        'matchedSkills': ['Flutter', 'State Management', 'Dart'],
        'missingSkills': ['Native iOS (Swift)'],
        'priorityImprovements': ['Add native iOS platform channel experience'],
        'interviewRiskAreas': ['Swift concurrency models'],
      };

      final result = MatchResult.fromJson(json);

      expect(result.matchScore, equals(92.5));
      expect(result.matchedSkills, containsAll(['Flutter', 'Dart']));
      expect(result.missingSkills, contains('Native iOS (Swift)'));
      expect(result.priorityImprovements.first, contains('platform channel'));
      expect(result.interviewRiskAreas.first, contains('Swift concurrency'));
    });
  });

  group('InterviewResult Entity Tests', () {
    test('InterviewResult.fromJson accurately parses interview summary payloads', () {
      final json = {
        'overallScore': 88.0,
        'categoryScores': {
          'Technical': 90.0,
          'Communication': 85.0,
          'Problem Solving': 89.0,
        },
        'strengths': ['Clear STAR formatting', 'Concise architecture explanation'],
        'improvements': ['Deepen explanation of error handling'],
        'summary': 'Candidate demonstrated strong architectural competence and structured communication.',
      };

      final result = InterviewResult.fromJson(json);

      expect(result.overallScore, equals(88.0));
      expect(result.categoryScores['Technical'], equals(90.0));
      expect(result.categoryScores['Communication'], equals(85.0));
      expect(result.strengths.length, equals(2));
      expect(result.improvementAreas.first, contains('error handling'));
      expect(result.summary, contains('strong architectural competence'));
    });
  });
}
