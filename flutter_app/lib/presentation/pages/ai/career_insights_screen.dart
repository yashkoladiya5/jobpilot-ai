import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/career_insight.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_event.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class CareerInsightsScreen extends StatefulWidget {
  const CareerInsightsScreen({super.key});

  @override
  State<CareerInsightsScreen> createState() => _CareerInsightsScreenState();
}

class _CareerInsightsScreenState extends State<CareerInsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CareerInsightsBloc>().add(const LoadCareerInsights());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<CareerInsightsBloc>()
                .add(const RefreshCareerInsights()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<CareerInsightsBloc>()
              .add(const RefreshCareerInsights());
        },
        child: BlocBuilder<CareerInsightsBloc, CareerInsightsState>(
          builder: (context, state) {
            return switch (state) {
              CareerInsightsInitial() => const SizedBox.shrink(),
              CareerInsightsLoading() => const _InsightsShimmer(),
              CareerInsightsLoaded(:final insight) =>
                _buildContent(insight),
              CareerInsightsError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () => context
                      .read<CareerInsightsBloc>()
                      .add(const LoadCareerInsights()),
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(CareerInsight insight) {
    final theme = Theme.of(context);
    final lastUpdated = insight.history.isNotEmpty
        ? DateFormat('MMM dd, yyyy').format(insight.history.last.date)
        : 'Today';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Career Insights',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Updated: $lastUpdated',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildCareerScore(insight.careerScore),
        const SizedBox(height: 28),
        Text(
          'Score Breakdown',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildScoreCardsGrid(insight),
        const SizedBox(height: 24),
        Text(
          'Skill Gaps',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSkillGaps(insight.skillGaps),
        const SizedBox(height: 24),
        Text(
          'Recommendations',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRecommendations(insight.recommendations),
        const SizedBox(height: 24),
        if (insight.history.isNotEmpty) _buildViewHistoryButton(insight),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCareerScore(double score) {
    final color = _scoreColor(score);

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: score / 100),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 14,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(value * 100).round()}',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    Text(
                      'Career Score',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreCardsGrid(CareerInsight insight) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                icon: Icons.record_voice_over,
                label: 'Interview Readiness',
                score: insight.interviewReadiness,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                icon: Icons.description,
                label: 'Resume Strength',
                score: insight.resumeStrength,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildScoreCard(
                icon: Icons.work,
                label: 'Job Match Quality',
                score: insight.jobMatchQuality,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScoreCard(
                icon: Icons.trending_up,
                label: 'App. Success Rate',
                score: insight.applicationSuccessRate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreCard({
    required IconData icon,
    required String label,
    required double score,
  }) {
    final color = _scoreColor(score);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const Spacer(),
                Text(
                  '${score.round()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 6,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillGaps(List<String> gaps) {
    if (gaps.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 12),
              Text(
                'No skill gaps identified!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: gaps
          .map(
            (gap) => Chip(
              label: Text(gap),
              avatar: const Icon(Icons.warning_amber, size: 18),
              backgroundColor: AppColors.warning.withValues(alpha: 0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecommendations(List<String> recommendations) {
    if (recommendations.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline,
                  color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'No recommendations yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: recommendations.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final recommendation = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => _onRecommendationTap(recommendation, context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.check, size: 18, color: AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommendation $index',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(recommendation),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildViewHistoryButton(CareerInsight insight) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showHistoryDialog(context, insight),
        icon: const Icon(Icons.timeline),
        label: const Text('View History'),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, CareerInsight insight) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Career Progress'),
        content: SizedBox(
          width: double.maxFinite,
          height: 220,
          child: Column(
            children: [
              Expanded(
                child: _buildHistoryChart(insight.history),
              ),
              const SizedBox(height: 12),
              Text(
                'Career score trend over time',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onRecommendationTap(String recommendation, BuildContext context) {
    final lower = recommendation.toLowerCase();
    if (lower.contains('resume')) {
      context.goNamed('resumeAnalyses');
    } else if (lower.contains('interview') || lower.contains('prep')) {
      context.goNamed('interviewSessions');
    } else if (lower.contains('match') || lower.contains('job')) {
      context.goNamed('aiMatch');
    } else {
      context.goNamed('aiHub');
    }
  }

  Widget _buildHistoryChart(List<CareerHistoryPoint> history) {
    final sorted = List<CareerHistoryPoint>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomPaint(
            size: const Size(double.infinity, 150),
            painter: _HistoryChartPainter(sorted),
          ),
        ),
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }
}

class _HistoryChartPainter extends CustomPainter {
  final List<CareerHistoryPoint> points;

  _HistoryChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    const padding = Offset(30, 20);
    final chartWidth = size.width - padding.dx * 2;
    final chartHeight = size.height - padding.dy * 2;

    final minScore =
        points.map((p) => p.score).reduce((a, b) => a < b ? a : b);
    final maxScore =
        points.map((p) => p.score).reduce((a, b) => a > b ? a : b);
    final scoreRange = (maxScore - minScore).clamp(10, double.infinity);

    for (var i = 0; i < points.length; i++) {
      final x = padding.dx + (i / (points.length - 1)) * chartWidth;
      final y = padding.dy +
          chartHeight -
          ((points[i].score - minScore) / scoreRange) * chartHeight;

      if (i == 0) {
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      } else {
        final prevX =
            padding.dx + ((i - 1) / (points.length - 1)) * chartWidth;
        final prevY = padding.dy +
            chartHeight -
            ((points[i - 1].score - minScore) / scoreRange) * chartHeight;
        canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HistoryChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _InsightsShimmer extends StatelessWidget {
  const _InsightsShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 24,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 16,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(4, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(2, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
