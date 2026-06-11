import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_event.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_state.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
    context.read<AuthBloc>().add(const CheckAuthStatus());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        state.whenOrNull(
          authenticated: (_) => context.go(AppConstants.dashboardRoute),
          unauthenticated: (_) => _handleUnauthenticated(),
          authError: (_) => _handleUnauthenticated(),
        );
      },
      child: Scaffold(
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.primary.withValues(alpha: 0.3),
                  highlightColor: AppColors.primary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.work_history_rounded,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppConstants.appName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUnauthenticated() async {
    final onboardingDone =
        await _storage.read(key: AppConstants.onboardingDoneKey);
    if (mounted) {
      if (onboardingDone == null) {
        context.go('/onboarding');
      } else {
        context.go(AppConstants.loginRoute);
      }
    }
  }
}
