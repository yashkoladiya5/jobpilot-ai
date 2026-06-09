import 'dart:io' show Platform;

class AppConstants {
  AppConstants._();

  static const String appName = 'JobPilot AI';
  // Android emulator uses 10.0.2.2 to reach host machine.
  // If it doesn't work on your setup, replace with your Mac's LAN IP.
  static const String _androidHost = '192.168.1.13';
  static const String _localHost = 'localhost';

  static String get apiBaseUrl {
    if (Platform.isAndroid) return 'http://$_androidHost:3000/api';
    return 'http://$_localHost:3000/api';
  }

  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String onboardingDoneKey = 'onboarding_done';

  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String jobsRoute = '/jobs';
  static const String jobCreateRoute = '/jobs/create';
  static const String jobDetailRoute = '/jobs/:id';
  static const String jobEditRoute = '/jobs/:id/edit';
  static const String resumesRoute = '/resumes';
}
