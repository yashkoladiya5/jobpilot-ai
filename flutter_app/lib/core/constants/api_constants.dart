import 'package:jobpilot_ai/core/constants/app_constants.dart';

class ApiConstants {
  ApiConstants._();

  static String get _baseUrl => AppConstants.apiBaseUrl;

  static String get login => '$_baseUrl/auth/login';
  static String get register => '$_baseUrl/auth/register';
  static String get me => '$_baseUrl/auth/me';

  static String get jobs => '$_baseUrl/jobs';
  static String jobDetail(String id) => '$_baseUrl/jobs/$id';

  static String get resumes => '$_baseUrl/resumes';
  static String resumeDetail(String id) => '$_baseUrl/resumes/$id';
  static String get uploadResume => '$_baseUrl/resumes/upload';
  static String resumeSetPrimary(String id) => '$_baseUrl/resumes/$id/primary';

  static String get dashboardStats => '$_baseUrl/dashboard/stats';
}
