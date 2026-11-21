import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';

void main() {
  group('DashboardStats Freezed Entity Tests', () {
    test('DashboardStats.fromJson parses full dashboard analytics payload', () {
      final json = {
        'totalApplications': 14,
        'byStatus': [
          {'status': 'SAVED', 'count': 4},
          {'status': 'APPLIED', 'count': 6},
          {'status': 'INTERVIEW', 'count': 3},
          {'status': 'OFFER', 'count': 1},
        ],
        'recentApplications': [
          {
            'id': 'app-1',
            'companyName': 'Google',
            'role': 'Senior Staff Engineer',
            'status': 'INTERVIEW',
            'appliedDate': '2026-11-18T10:00:00.000Z',
          },
        ],
        'recentActivity': 5,
        'resumeCount': 2,
      };

      final stats = DashboardStats.fromJson(json);

      expect(stats.totalApplications, equals(14));
      expect(stats.recentActivity, equals(5));
      expect(stats.resumeCount, equals(2));
      expect(stats.byStatus.length, equals(4));
      expect(stats.byStatus[2].status, equals('INTERVIEW'));
      expect(stats.byStatus[2].count, equals(3));
      expect(stats.recentApplications.first.companyName, equals('Google'));
      expect(stats.recentApplications.first.status, equals('INTERVIEW'));
    });

    test('DashboardStats handles empty statuses and recent applications', () {
      final json = {
        'totalApplications': 0,
        'byStatus': <Map<String, dynamic>>[],
        'recentApplications': <Map<String, dynamic>>[],
        'recentActivity': 0,
        'resumeCount': 0,
      };

      final stats = DashboardStats.fromJson(json);

      expect(stats.totalApplications, equals(0));
      expect(stats.byStatus, isEmpty);
      expect(stats.recentApplications, isEmpty);
    });
  });
}
