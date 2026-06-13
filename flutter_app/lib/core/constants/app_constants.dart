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

class AppLayoutConstants {
  AppLayoutConstants._();

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusExtraLarge = 16.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
