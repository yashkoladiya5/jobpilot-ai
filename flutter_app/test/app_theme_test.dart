import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AppTheme & AppColors Unit Tests', () {
    test('AppColors provides expected color values', () {
      expect(AppColors.primary, equals(const Color(0xFF1565C0)));
      expect(AppColors.secondary, equals(const Color(0xFF26A69A)));
      expect(AppColors.error, equals(const Color(0xFFD32F2F)));
      expect(AppColors.success, equals(const Color(0xFF388E3C)));
      expect(AppColors.warning, equals(const Color(0xFFF57C00)));
    });

    test('AppTheme.lightTheme initializes Material 3 and theme configurations', () {
      final theme = AppTheme.lightTheme;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, equals(AppColors.primary));
      expect(theme.colorScheme.secondary, equals(AppColors.secondary));
      expect(theme.scaffoldBackgroundColor, equals(AppColors.scaffoldBackground));

      // AppBar theme checks
      expect(theme.appBarTheme.centerTitle, isTrue);
      expect(theme.appBarTheme.elevation, equals(0));

      // Card theme checks
      expect(theme.cardTheme.elevation, equals(2));
      expect(theme.cardTheme.color, equals(AppColors.cardBackground));

      // SnackBar theme checks
      expect(theme.snackBarTheme.behavior, equals(SnackBarBehavior.floating));
    });
  });
}
