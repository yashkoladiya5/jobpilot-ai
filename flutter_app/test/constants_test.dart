import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';

void main() {
  group('AppConstants & ApiConstants Unit Tests', () {
    test('AppConstants contains correct application keys and routes', () {
      expect(AppConstants.appName, equals('JobPilot AI'));
      expect(AppConstants.authTokenKey, equals('auth_token'));
      expect(AppConstants.refreshTokenKey, equals('refresh_token'));
      expect(AppConstants.dashboardRoute, equals('/dashboard'));
      expect(AppConstants.jobsRoute, equals('/jobs'));
      expect(AppConstants.resumesRoute, equals('/resumes'));
    });

    test('AppLayoutConstants defines standard padding and corner radii', () {
      expect(AppLayoutConstants.paddingSmall, equals(8.0));
      expect(AppLayoutConstants.paddingMedium, equals(16.0));
      expect(AppLayoutConstants.paddingLarge, equals(24.0));
      expect(AppLayoutConstants.borderRadiusSmall, equals(4.0));
      expect(AppLayoutConstants.borderRadiusMedium, equals(8.0));
      expect(AppLayoutConstants.borderRadiusLarge, equals(12.0));
    });

    test('ApiConstants generates expected endpoint URL structures', () {
      expect(ApiConstants.login, contains('/auth/login'));
      expect(ApiConstants.register, contains('/auth/register'));
      expect(ApiConstants.jobs, contains('/jobs'));
      expect(ApiConstants.jobDetail('job-123'), contains('/jobs/job-123'));
      expect(ApiConstants.resumes, contains('/resumes'));
      expect(ApiConstants.resumeDetail('res-456'), contains('/resumes/res-456'));
      expect(ApiConstants.resumeSetPrimary('res-456'), contains('/resumes/res-456/primary'));
      expect(ApiConstants.dashboardStats, contains('/dashboard/stats'));
      expect(ApiConstants.coverLetter('cl-789'), contains('/ai/cover-letter/cl-789'));
    });
  });
}
