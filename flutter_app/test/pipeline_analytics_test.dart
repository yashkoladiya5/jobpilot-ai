import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';

void main() {
  group('PipelineAnalytics Entity Tests', () {
    test('PipelineAnalytics.fromJson parses comprehensive pipeline stats', () {
      final json = {
        'totalApplications': 25,
        'byStatus': [
          {'status': 'SAVED', 'count': 5, 'percentage': 20.0},
          {'status': 'APPLIED', 'count': 12, 'percentage': 48.0},
          {'status': 'INTERVIEW', 'count': 6, 'percentage': 24.0},
          {'status': 'OFFER', 'count': 2, 'percentage': 8.0},
        ],
        'conversionRates': {
          'appliedToInterview': 0.50,
          'interviewToOffer': 0.33,
          'overallSuccessRate': 0.08,
        },
        'averageDaysInPipeline': 14.5,
        'topCompanies': [
          {'company': 'Google', 'count': 4},
          {'company': 'Stripe', 'count': 2},
        ],
        'monthlyTrend': [
          {'month': 'Oct 2026', 'count': 10},
          {'month': 'Nov 2026', 'count': 15},
        ],
      };

      final analytics = PipelineAnalytics.fromJson(json);

      expect(analytics.totalApplications, equals(25));
      expect(analytics.averageDaysInPipeline, equals(14.5));
      expect(analytics.byStatus.length, equals(4));
      expect(analytics.byStatus[2].status, equals('INTERVIEW'));
      expect(analytics.byStatus[2].count, equals(6));
      expect(analytics.conversionRates.appliedToInterview, equals(0.50));
      expect(analytics.conversionRates.interviewToOffer, equals(0.33));
      expect(analytics.topCompanies.first.company, equals('Google'));
      expect(analytics.monthlyTrend.last.month, equals('Nov 2026'));
    });

    test('PipelineAnalytics.fromJson handles null and empty sub-collections gracefully', () {
      final json = {
        'totalApplications': null,
        'byStatus': null,
        'conversionRates': null,
        'averageDaysInPipeline': null,
        'topCompanies': null,
        'monthlyTrend': null,
      };

      final analytics = PipelineAnalytics.fromJson(json);

      expect(analytics.totalApplications, equals(0));
      expect(analytics.averageDaysInPipeline, equals(0.0));
      expect(analytics.byStatus, isEmpty);
      expect(analytics.topCompanies, isEmpty);
      expect(analytics.monthlyTrend, isEmpty);
      expect(analytics.conversionRates.appliedToInterview, equals(0.0));
    });
  });
}
