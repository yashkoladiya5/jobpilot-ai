import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class JobAnalysesScreen extends StatefulWidget {
  const JobAnalysesScreen({super.key});

  @override
  State<JobAnalysesScreen> createState() => _JobAnalysesScreenState();
}

class _JobAnalysesScreenState extends State<JobAnalysesScreen> {
  List<JobAnalysis>? _lastAnalyses;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Analyses'),
      ),
      body: BlocBuilder<AiJobBloc, AiJobState>(
        builder: (context, state) {
          return switch (state) {
            AiJobInitial() => const SizedBox.shrink(),
            AiJobAnalyzing() => _lastAnalyses != null
                ? _buildList(_lastAnalyses!)
                : const _JobAnalysesShimmer(),
            AiJobAnalysesLoaded(:final analyses) =>
              _buildList(_lastAnalyses = analyses),
            AiJobLoaded() => _lastAnalyses != null
                ? _buildList(_lastAnalyses!)
                : const _JobAnalysesShimmer(),
            AiJobError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () {},
              ),
          };
        },
      ),
    );
  }

  Widget _buildList(List<JobAnalysis> analyses) {
    if (analyses.isEmpty) {
      return const EmptyState(
        icon: Icons.analytics_outlined,
        message: 'No job analyses yet.\nAnalyze a job description to get started.',
        actionLabel: 'Analyze Job',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: analyses.length,
        itemBuilder: (context, index) {
          final analysis = analyses[index];
          return _buildAnalysisCard(analysis);
        },
      ),
    );
  }

  Widget _buildAnalysisCard(JobAnalysis analysis) {
    final scoreColor = analysis.matchScore >= 80
        ? AppColors.success
        : analysis.matchScore >= 60
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.work, color: AppColors.primary),
        ),
        title: Text(
          analysis.jobTitle ?? 'Job Analysis',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${analysis.requiredSkills.length} required skills',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (analysis.matchScore > 0)
              Text(
                '${analysis.matchScore.round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd').format(analysis.analyzedAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        onTap: () => context.push('/ai/job/analysis/${analysis.id}'),
      ),
    );
  }
}

class _JobAnalysesShimmer extends StatelessWidget {
  const _JobAnalysesShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(4, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
    );
  }
}
