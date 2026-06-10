import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';

class AiHubScreen extends StatelessWidget {
  const AiHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Supercharge your job search',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ..._features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AiFeatureCard(
              icon: f.icon,
              iconColor: f.iconColor,
              title: f.title,
              description: f.description,
              onTap: () => context.push(f.route),
            ),
          )),
        ],
      ),
    );
  }
}

class _AiFeature {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String route;
  const _AiFeature({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.route,
  });
}

const _features = [
  _AiFeature(
    icon: Icons.description,
    iconColor: AppColors.primary,
    title: 'Resume Analysis',
    description: 'Get AI-powered feedback on your resume with ATS scoring',
    route: '/ai/resume/analyses',
  ),
  _AiFeature(
    icon: Icons.work,
    iconColor: AppColors.secondary,
    title: 'Job Description Analysis',
    description: 'Analyze job descriptions and identify key requirements',
    route: '/ai/job/analyze',
  ),
  _AiFeature(
    icon: Icons.compare_arrows,
    iconColor: AppColors.warning,
    title: 'Resume Matching',
    description: 'Match your resume against job descriptions',
    route: '/ai/match',
  ),
  _AiFeature(
    icon: Icons.record_voice_over,
    iconColor: AppColors.primaryLight,
    title: 'Interview Prep',
    description: 'Practice with AI-generated interview questions',
    route: '/ai/interview/sessions',
  ),
  _AiFeature(
    icon: Icons.trending_up,
    iconColor: AppColors.success,
    title: 'Career Insights',
    description: 'Get personalized career recommendations and insights',
    route: '/ai/insights',
  ),
];

class _AiFeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AiFeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
