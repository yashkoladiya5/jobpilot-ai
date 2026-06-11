import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_event.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_event.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_state.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/stats_card.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const LoadDashboard());
    context.read<CareerInsightsBloc>().add(const LoadCareerInsights());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobPilot AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutRequested()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(const RefreshDashboard());
          context
              .read<CareerInsightsBloc>()
              .add(const RefreshCareerInsights());
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return switch (state) {
              DashboardInitial() => const SizedBox.shrink(),
              DashboardLoading() => const _DashboardShimmer(),
              DashboardLoaded(:final stats) =>
                _buildDashboardContent(context, stats),
              DashboardError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () =>
                      context.read<DashboardBloc>().add(const LoadDashboard()),
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardStats stats) {
    final interviewCount = stats.byStatus
        .where((s) => s.status == 'INTERVIEW')
        .fold(0, (sum, s) => sum + s.count);
    final offerCount = stats.byStatus
        .where((s) => s.status == 'OFFER')
        .fold(0, (sum, s) => sum + s.count);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCareerInsightsSection(context),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              StatsCard(
                icon: Icons.work_outline,
                iconBackgroundColor: AppColors.primary,
                number: stats.totalApplications.toString(),
                label: 'Total Applications',
              ),
              const SizedBox(width: 12),
              StatsCard(
                icon: Icons.people_outline,
                iconBackgroundColor: AppColors.warning,
                number: interviewCount.toString(),
                label: 'Interviews',
              ),
              const SizedBox(width: 12),
              StatsCard(
                icon: Icons.check_circle_outline,
                iconBackgroundColor: AppColors.success,
                number: offerCount.toString(),
                label: 'Offers',
              ),
              const SizedBox(width: 12),
              StatsCard(
                icon: Icons.trending_up,
                iconBackgroundColor: AppColors.secondary,
                number: stats.recentActivity.toString(),
                label: 'Recent Activity',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildQuickActions(context),
        const SizedBox(height: 24),
        Text(
          'Recent Applications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (stats.recentApplications.isEmpty)
          const EmptyState(
            icon: Icons.inbox_outlined,
            message: 'No recent applications',
          )
        else
          ...stats.recentApplications.take(5).map(
                (app) => _buildRecentApplicationItem(context, app),
              ),
      ],
    );
  }

  Widget _buildCareerInsightsSection(BuildContext context) {
    return BlocBuilder<CareerInsightsBloc, CareerInsightsState>(
      builder: (context, state) {
        return switch (state) {
          CareerInsightsInitial() || CareerInsightsLoading() =>
            _buildCIShimmer(),
          CareerInsightsLoaded(:final insight) =>
            _buildCICard(context, insight),
          CareerInsightsError() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildCICard(BuildContext context, dynamic insight) {
    final score = insight.careerScore.round();
    final color = score >= 75
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.goNamed('careerInsights'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: insight.careerScore / 100,
                        strokeWidth: 5,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation(color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Career Insights',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your overall career health score',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.goNamed('careerInsights'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View'),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCIShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: EdgeInsets.zero,
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionCard(
                context,
                icon: Icons.auto_awesome,
                label: 'Analyze a Resume',
                color: AppColors.primary,
                onTap: () => context.goNamed('aiHub'),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                context,
                icon: Icons.work,
                label: 'Match a Job',
                color: AppColors.secondary,
                onTap: () => context.goNamed('aiMatch'),
              ),
              const SizedBox(width: 12),
              _buildActionCard(
                context,
                icon: Icons.record_voice_over,
                label: 'Start Interview Prep',
                color: AppColors.warning,
                onTap: () => context.goNamed('interviewSessions'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentApplicationItem(
    BuildContext context,
    RecentApplication app,
  ) {
    final applicationStatus = ApplicationStatus.values.firstWhere(
      (e) => e.value == app.status,
      orElse: () => ApplicationStatus.saved,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            app.companyName.isNotEmpty
                ? app.companyName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          app.companyName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(app.role),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusChip(status: applicationStatus),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(app.appliedDate),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: EdgeInsets.zero,
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(4, (_) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 150,
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
        ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 72,
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
