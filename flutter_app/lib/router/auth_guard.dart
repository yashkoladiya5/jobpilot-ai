import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';

class AuthGuard {
  final FlutterSecureStorage _storage;

  AuthGuard({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final Set<String> _publicRoutes = {
    AppConstants.splashRoute,
    AppConstants.loginRoute,
    AppConstants.registerRoute,
  };

  Future<String?> guard(BuildContext context, GoRouterState state) async {
    final location = state.uri.toString();
    final isAuthenticated = await _isLoggedIn();
    final isPublicRoute = _publicRoutes.contains(location);

    if (!isAuthenticated && !isPublicRoute) {
      return AppConstants.loginRoute;
    }

    if (isAuthenticated && isPublicRoute && location != AppConstants.splashRoute) {
      return AppConstants.dashboardRoute;
    }

    return null;
  }

  Future<bool> _isLoggedIn() async {
    try {
      final token = await _storage.read(key: AppConstants.authTokenKey);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
