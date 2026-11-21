import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';

void main() {
  group('CareerInsight and CareerHistoryPoint Entity Tests', () {
    test('CareerHistoryPoint.fromJson parses valid date and score', () {
      final json = {
        'date': '2026-11-20T10:00:00.000Z',
        'score': 78.5,
        'label': 'Week 46',
      };

      final point = CareerHistoryPoint.fromJson(json);

      expect(point.score, equals(78.5));
      expect(point.label, equals('Week 46'));
      expect(point.date.year, equals(2026));
    });

    test('CareerInsight.fromJson deserializes full payload with history points', () {
      final json = {
        'careerScore': 85.0,
        'interviewReadiness': 80.0,
        'resumeStrength': 90.0,
        'jobMatchQuality': 84.0,
        'applicationSuccessRate': 72.0,
        'skillGaps': ['Distributed Tracing', 'Kubernetes'],
        'recommendations': ['Prepare mock interview for system design'],
        'weeklyProgress': [
          {
            'date': '2026-11-13T10:00:00.000Z',
            'score': 81.0,
            'label': 'W1',
          },
          {
            'date': '2026-11-20T10:00:00.000Z',
            'score': 85.0,
            'label': 'W2',
          },
        ],
      };

      final insight = CareerInsight.fromJson(json);

      expect(insight.careerScore, equals(85.0));
      expect(insight.interviewReadiness, equals(80.0));
      expect(insight.resumeStrength, equals(90.0));
      expect(insight.jobMatchQuality, equals(84.0));
      expect(insight.applicationSuccessRate, equals(72.0));
      expect(insight.skillGaps, contains('Kubernetes'));
      expect(insight.recommendations.first, contains('mock interview'));
      expect(insight.history.length, equals(2));
      expect(insight.history[1].score, equals(85.0));
    });

    test('CareerInsight.fromJson defaults empty history when weeklyProgress is null', () {
      final json = {
        'careerScore': 65.0,
        'interviewReadiness': 60.0,
        'resumeStrength': 70.0,
        'jobMatchQuality': 62.0,
        'applicationSuccessRate': 55.0,
        'skillGaps': <String>[],
        'recommendations': <String>[],
        'weeklyProgress': null,
      };

      final insight = CareerInsight.fromJson(json);

      expect(insight.careerScore, equals(65.0));
      expect(insight.history, isEmpty);
    });
  });
}
