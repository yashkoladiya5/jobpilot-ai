import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_event.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_state.dart';

class AiHubScreen extends StatefulWidget {
  const AiHubScreen({super.key});

  @override
  State<AiHubScreen> createState() => _AiHubScreenState();
}

class _AiHubScreenState extends State<AiHubScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CareerInsightsBloc>().add(const LoadCareerInsights());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CareerInsightsBloc, CareerInsightsState>(
        builder: (context, state) {
          final insight = switch (state) {
            CareerInsightsLoaded(:final insight) => insight,
            _ => null,
          };
          final isLoading =
              state is CareerInsightsInitial || state is CareerInsightsLoading;
          final errorMessage =
              state is CareerInsightsError ? state.message : null;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(insight: insight, isLoading: isLoading),
                ),
                if (errorMessage != null)
                  SliverToBoxAdapter(
                    child: _ErrorBanner(
                      message: errorMessage,
                      onRetry: () => context
                          .read<CareerInsightsBloc>()
                          .add(const RefreshCareerInsights()),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _ScoreCardsRow(
                      insight: insight, isLoading: isLoading),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Recommended Actions'),
                ),
                const SliverToBoxAdapter(child: _RecommendedActions()),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(
                  child: _SectionHeader(title: 'Quick Actions'),
                ),
                const SliverToBoxAdapter(child: _QuickActionsGrid()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

Color _scoreColor(double score) {
  if (score >= 80) return AppColors.success;
  if (score >= 50) return AppColors.warning;
  return AppColors.error;
}

List<_ScoreMetric> _buildMetrics(CareerInsight? insight) => [
      _ScoreMetric(
        icon: Icons.description,
        label: 'Resume Health',
        score: insight?.resumeStrength,
      ),
      _ScoreMetric(
        icon: Icons.analytics,
        label: 'ATS Score',
        score: insight?.applicationSuccessRate,
      ),
      _ScoreMetric(
        icon: Icons.work,
        label: 'Job Match Quality',
        score: insight?.jobMatchQuality,
      ),
      _ScoreMetric(
        icon: Icons.record_voice_over,
        label: 'Interview Readiness',
        score: insight?.interviewReadiness,
      ),
      _ScoreMetric(
        icon: Icons.trending_up,
        label: 'Career Score',
        score: insight?.careerScore,
      ),
    ];

class _ScoreMetric {
  final IconData icon;
  final String label;
  final double? score;

  const _ScoreMetric({
    required this.icon,
    required this.label,
    required this.score,
  });
}

class _Header extends StatelessWidget {
  final CareerInsight? insight;
  final bool isLoading;

  const _Header({required this.insight, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Career Command Center',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          if (isLoading)
            const _ShimmerBox(width: 200, height: 16, borderRadius: 4)
          else if (insight != null)
            Text(
              'Your overall career score: ${insight!.careerScore.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _scoreColor(insight!.careerScore),
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Text(
              'Your AI-powered career companion',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        color: AppColors.error.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCardsRow extends StatelessWidget {
  final CareerInsight? insight;
  final bool isLoading;

  const _ScoreCardsRow({required this.insight, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final metrics = _buildMetrics(insight);
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: metrics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final m = metrics[index];
          return _ScoreCard(
            icon: m.icon,
            label: m.label,
            score: m.score,
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? score;
  final bool isLoading;

  const _ScoreCard({
    required this.icon,
    required this.label,
    required this.score,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        score != null ? _scoreColor(score!) : AppColors.textHint;

    return SizedBox(
      width: 130,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const Spacer(),
                  if (isLoading)
                    const _ShimmerBox(width: 32, height: 14, borderRadius: 4)
                  else if (score != null)
                    Text(
                      '${score!.round()}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color,
                        height: 1,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (isLoading)
                const _ShimmerBox(width: double.infinity, height: 4, borderRadius: 2)
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: score != null ? score! / 100 : 0,
                    backgroundColor: color.withValues(alpha: 0.15),
                    color: color,
                    minHeight: 4,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
      ),
    );
  }
}

class _RecommendedActions extends StatelessWidget {
  const _RecommendedActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        icon: Icons.description,
        color: AppColors.primary,
        iconBgColor: AppColors.primary.withValues(alpha: 0.1),
        title: 'Analyze your resume',
        description: 'Get AI-powered feedback with ATS scoring',
        route: '/ai/resume/analyses',
      ),
      _ActionData(
        icon: Icons.work,
        color: AppColors.secondary,
        iconBgColor: AppColors.secondary.withValues(alpha: 0.1),
        title: 'Match a job description',
        description: 'See how your resume stacks up against any role',
        route: '/ai/match',
      ),
      _ActionData(
        icon: Icons.record_voice_over,
        color: AppColors.warning,
        iconBgColor: AppColors.warning.withValues(alpha: 0.1),
        title: 'Start interview prep',
        description: 'Practice with AI-generated questions',
        route: '/ai/interview/sessions',
      ),
      _ActionData(
        icon: Icons.trending_up,
        color: AppColors.primaryLight,
        iconBgColor: AppColors.primaryLight.withValues(alpha: 0.1),
        title: 'View career insights',
        description: 'Personalized recommendations and skill gap analysis',
        route: '/ai/insights',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: actions.map((a) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ActionCard(data: a),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionData {
  final IconData icon;
  final Color color;
  final Color iconBgColor;
  final String title;
  final String description;
  final String route;

  const _ActionData({
    required this.icon,
    required this.color,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.route,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionData data;

  const _ActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push(data.route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: data.iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.description,
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

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.description,
                  label: 'Analyze Resume',
                  onTap: () => context.push('/ai/resume/analyses'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.work,
                  label: 'Analyze Job',
                  onTap: () => context.push('/ai/job/analyze'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.record_voice_over,
                  label: 'Start Interview',
                  onTap: () => context.push('/ai/interview/sessions'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.trending_up,
                  label: 'View Insights',
                  onTap: () => context.push('/ai/insights'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              AppColors.divider,
              AppColors.textHint.withValues(alpha: 0.4),
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}
