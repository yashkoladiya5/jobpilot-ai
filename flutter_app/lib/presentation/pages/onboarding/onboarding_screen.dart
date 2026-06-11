import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _storage = const FlutterSecureStorage();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(String destination) async {
    await _storage.write(
      key: AppConstants.onboardingDoneKey,
      value: 'true',
    );
    if (mounted) {
      context.go(destination);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage < 2)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () =>
                      _completeOnboarding(AppConstants.loginRoute),
                  child: const Text('Skip'),
                ),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildPage(
                    icon: Icons.work_outline,
                    title: 'Track Every Application',
                    description:
                        'Keep track of jobs, resumes, and applications all in one place',
                    color: AppColors.primary,
                  ),
                  _buildPage(
                    icon: Icons.auto_awesome,
                    title: 'AI That Helps You Get Hired',
                    description:
                        'Analyze your resume, match with jobs, and ace your interviews with AI guidance',
                    color: AppColors.secondary,
                  ),
                  _buildLastPage(),
                ],
              ),
            ),
            _buildDots(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(icon, size: 64, color: color),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.rocket_launch,
              size: 64,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Ready to Land Your Dream Job?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload your resume, analyze job descriptions, and track your progress',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  _completeOnboarding(AppConstants.registerRoute),
              child: const Text('Create Account'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  _completeOnboarding(AppConstants.loginRoute),
              child: const Text('I already have an account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
