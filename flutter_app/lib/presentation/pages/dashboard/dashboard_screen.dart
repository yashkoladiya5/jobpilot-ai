import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/dashboard_stats.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/auth/auth_event.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/stats_card.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';

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
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return switch (state) {
              DashboardInitial() => const SizedBox.shrink(),
              DashboardLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
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
        .where((s) => s.status == 'interview')
        .fold(0, (sum, s) => sum + s.count);
    final offerCount = stats.byStatus
        .where((s) => s.status == 'offer')
        .fold(0, (sum, s) => sum + s.count);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
            style: TextStyle(
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
