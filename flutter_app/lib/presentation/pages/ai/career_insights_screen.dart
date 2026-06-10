import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          context.read<CareerInsightsBloc>().add(const RefreshCareerInsights());
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCareerScore(insight.careerScore),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMiniCard(
                'Interview\nReadiness',
                insight.interviewReadiness,
                AppColors.primary,
              ),
              const SizedBox(width: 10),
              _buildMiniCard(
                'Resume\nStrength',
                insight.resumeStrength,
                AppColors.secondary,
              ),
              const SizedBox(width: 10),
              _buildMiniCard(
                'Job Match\nQuality',
                insight.jobMatchQuality,
                AppColors.warning,
              ),
              const SizedBox(width: 10),
              _buildMiniCard(
                'Application\nSuccess',
                insight.applicationSuccessRate,
                AppColors.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Skill Gaps',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (insight.skillGaps.isEmpty)
          const Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: AppColors.success),
                  SizedBox(width: 12),
                  Text('No major skill gaps detected!'),
                ],
              ),
            ),
          )
        else
          ...insight.skillGaps.map(
            (gap) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber,
                      size: 20, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(child: Text(gap)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        Text('Recommendations',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (insight.recommendations.isEmpty)
          const Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No recommendations yet.'),
            ),
          )
        else
          ...insight.recommendations.map(
            (r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 20, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(child: Text(r)),
                  ],
                ),
              ),
            ),
          ),
        if (insight.history.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Career Progress',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildHistoryChart(insight.history),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCareerScore(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.round()}',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold, color: color),
                    ),
                    Text(
                      'Career Score',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(String label, double score, Color color) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 3,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    Text(
                      '${score.round()}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryChart(List<CareerHistoryPoint> history) {
    final sorted = List<CareerHistoryPoint>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 120,
          child: CustomPaint(
            size: Size.infinite,
            painter: _HistoryChartPainter(sorted),
          ),
        ),
      ),
    );
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

    final minScore = points.map((p) => p.score).reduce(
          (a, b) => a < b ? a : b,
        );
    final maxScore = points.map((p) => p.score).reduce(
          (a, b) => a > b ? a : b,
        );
    final scoreRange = (maxScore - minScore).clamp(10, double.infinity);

    for (var i = 0; i < points.length; i++) {
      final x = padding.dx + (i / (points.length - 1)) * chartWidth;
      final y = padding.dy +
          chartHeight -
          ((points[i].score - minScore) / scoreRange) * chartHeight;

      if (i == 0) {
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      } else {
        final prevX = padding.dx +
            ((i - 1) / (points.length - 1)) * chartWidth;
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
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(4, (_) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 130,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
