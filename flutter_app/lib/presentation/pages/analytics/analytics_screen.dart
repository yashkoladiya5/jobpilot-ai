import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/pipeline_analytics.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_event.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(const RefreshAllAnalytics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pipeline Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<AnalyticsBloc>().add(const RefreshAllAnalytics()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AnalyticsBloc>().add(const RefreshAllAnalytics());
        },
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            return switch (state) {
              AnalyticsInitial() => const SizedBox.shrink(),
              AnalyticsLoading() => const _AnalyticsShimmer(),
              AnalyticsLoaded(:final analytics, :final timeline) =>
                _buildContent(analytics, timeline),
              AnalyticsError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () => context
                      .read<AnalyticsBloc>()
                      .add(const RefreshAllAnalytics()),
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      PipelineAnalytics analytics, List<TimelineEntry>? timeline) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(analytics),
        const SizedBox(height: 24),
        _buildSuccessRateRing(analytics),
        const SizedBox(height: 28),
        _buildFunnelSection(analytics),
        const SizedBox(height: 28),
        Text(
          'Status Breakdown',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildStatusBreakdown(analytics.byStatus),
        const SizedBox(height: 28),
        Text(
          'Conversion Rates',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildConversionRates(analytics.conversionRates),
        const SizedBox(height: 28),
        Text(
          'Top Companies',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTopCompanies(analytics.topCompanies),
        const SizedBox(height: 28),
        Text(
          'Monthly Trend',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildMonthlyTrend(analytics.monthlyTrend),
        if (timeline != null && timeline.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text(
            'Weekly Activity',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTimelineSection(timeline),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader(PipelineAnalytics analytics) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Application Pipeline',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${analytics.totalApplications} total applications',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Text(
          '${analytics.averageDaysInPipeline.toStringAsFixed(1)} days avg',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildSuccessRateRing(PipelineAnalytics analytics) {
    final rate = analytics.conversionRates.overallSuccessRate;
    final color = _rateColor(rate);

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: rate / 100),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 12,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(value * 100).round()}%',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    Text(
                      'Success Rate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
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

  Widget _buildFunnelSection(PipelineAnalytics analytics) {
    final statuses = analytics.byStatus;
    if (statuses.isEmpty) return const SizedBox.shrink();

    final funnelOrder = ['SAVED', 'APPLIED', 'INTERVIEW', 'OFFER'];
    final funnelColors = <String, Color>{
      'SAVED': AppColors.textSecondary,
      'APPLIED': AppColors.primary,
      'INTERVIEW': AppColors.warning,
      'OFFER': AppColors.success,
    };

    final orderedStatuses = funnelOrder
        .map((s) => statuses.firstWhere(
              (st) => st.status.toUpperCase() == s,
              orElse: () => StatusCount(status: s, count: 0, percentage: 0),
            ))
        .toList();

    final maxCount = orderedStatuses
        .map((s) => s.count)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (var i = 0; i < orderedStatuses.length; i++) ...[
              _buildFunnelRow(
                orderedStatuses[i],
                funnelColors[orderedStatuses[i].status] ?? AppColors.textSecondary,
                maxCount,
              ),
              if (i < orderedStatuses.length - 1) ...[
                const SizedBox(height: 4),
                _buildConversionArrow(
                  i < orderedStatuses.length - 1
                      ? orderedStatuses[i + 1].count
                      : 0,
                  orderedStatuses[i].count,
                ),
                const SizedBox(height: 4),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFunnelRow(
      StatusCount statusCount, Color color, int maxCount) {
    final fraction = maxCount > 0 ? statusCount.count / maxCount : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            statusCount.status,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: fraction),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return Container(
                        height: 32,
                        width: constraints.maxWidth * value,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '${statusCount.count}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildConversionArrow(int nextCount, int currentCount) {
    final rate = currentCount > 0
        ? ((nextCount / currentCount) * 100).toStringAsFixed(0)
        : '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.arrow_downward, size: 14, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          '$rate%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildStatusBreakdown(List<StatusCount> statuses) {
    if (statuses.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No status data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: statuses.map((status) {
        final color = _statusColor(status.status);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    status.status,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Text(
                  '${status.count}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${status.percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConversionRates(ConversionRates rates) {
    final metrics = [
      _ConversionMetric(
        label: 'Applied \u2192 Interview',
        rate: rates.appliedToInterview,
      ),
      _ConversionMetric(
        label: 'Interview \u2192 Offer',
        rate: rates.interviewToOffer,
      ),
      _ConversionMetric(
        label: 'Overall Success',
        rate: rates.overallSuccessRate,
      ),
    ];

    return Column(
      children: metrics.map((metric) {
        final color = _rateColor(metric.rate);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      metric.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      '${metric.rate.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: metric.rate / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopCompanies(List<CompanyCount> companies) {
    if (companies.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No company data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    final maxCount =
        companies.map((c) => c.count).reduce((a, b) => a > b ? a : b);

    return Column(
      children: companies.map((company) {
        final fraction = maxCount > 0 ? company.count / maxCount : 0.0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        company.company,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${company.count}',
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        backgroundColor: AppColors.divider,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyTrend(List<MonthlyTrend> trends) {
    if (trends.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No trend data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    final maxValue = trends
        .map((t) =>
            [t.applications, t.interviews, t.offers].reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildLegendDot(AppColors.primary, 'Applications'),
                const SizedBox(width: 16),
                _buildLegendDot(AppColors.warning, 'Interviews'),
                const SizedBox(width: 16),
                _buildLegendDot(AppColors.success, 'Offers'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barAreaWidth = constraints.maxWidth;
                  final groupWidth = barAreaWidth / trends.length;
                  final barWidth = groupWidth * 0.22;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: trends.map((trend) {
                      final appHeight = maxValue > 0
                          ? (trend.applications / maxValue) * 130
                          : 0.0;
                      final intHeight = maxValue > 0
                          ? (trend.interviews / maxValue) * 130
                          : 0.0;
                      final offerHeight = maxValue > 0
                          ? (trend.offers / maxValue) * 130
                          : 0.0;

                      return SizedBox(
                        width: groupWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBar(appHeight, barWidth, AppColors.primary),
                                const SizedBox(width: 2),
                                _buildBar(
                                    intHeight, barWidth, AppColors.warning),
                                const SizedBox(width: 2),
                                _buildBar(
                                    offerHeight, barWidth, AppColors.success),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              trend.month,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, double width, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: height),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          width: width,
          height: value,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          ),
        );
      },
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection(List<TimelineEntry> timeline) {
    final maxCount =
        timeline.map((t) => t.count).reduce((a, b) => a > b ? a : b);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / timeline.length;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: timeline.map((entry) {
                      final fraction =
                          maxCount > 0 ? entry.count / maxCount : 0.0;
                      final barHeight = fraction * 90;
                      final color = _timelineColor(entry);

                      return SizedBox(
                        width: itemWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${entry.count}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: barHeight),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return Container(
                                  height: value,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.week,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textHint,
                                    fontSize: 8,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rateColor(double rate) {
    if (rate >= 60) return AppColors.success;
    if (rate >= 30) return AppColors.warning;
    return AppColors.error;
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SAVED':
        return AppColors.textSecondary;
      case 'APPLIED':
        return AppColors.primary;
      case 'INTERVIEW':
        return AppColors.warning;
      case 'OFFER':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _timelineColor(TimelineEntry entry) {
    final statuses = entry.statuses;
    if (statuses.containsKey('OFFER') && statuses['OFFER']! > 0) {
      return AppColors.success;
    }
    if (statuses.containsKey('INTERVIEW') && statuses['INTERVIEW']! > 0) {
      return AppColors.warning;
    }
    return AppColors.primary;
  }
}

class _ConversionMetric {
  final String label;
  final double rate;

  const _ConversionMetric({required this.label, required this.rate});
}

class _AnalyticsShimmer extends StatelessWidget {
  const _AnalyticsShimmer();

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
                width: 200,
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
                height: 14,
                width: 80,
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
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 28),
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
        ...List.generate(
          4,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
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
        ...List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
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
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
