import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_event.dart';
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
    context.read<AiJobBloc>().add(const LoadAllJobAnalyses());
  }

  Future<void> _onRefresh() {
    context.read<AiJobBloc>().add(const LoadAllJobAnalyses());
    return Future.value();
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
                onRetry: () => context.read<AiJobBloc>()
                    .add(const LoadAllJobAnalyses()),
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
        message: 'No job analyses yet.\nPaste a job description to analyze.',
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
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
        : analysis.matchScore >= 50
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        onTap: () {
          context.read<AiJobBloc>()
              .add(LoadJobAnalysis(analysis.id));
          context.push('/ai/job/analysis/${analysis.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.work, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.jobTitle ?? 'Job Analysis',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${analysis.requiredSkills.length} required skills',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (analysis.matchScore > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${analysis.matchScore.round()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: scoreColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('MMM dd').format(analysis.analyzedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
    );
  }
}
