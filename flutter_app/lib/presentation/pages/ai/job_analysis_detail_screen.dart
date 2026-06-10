import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class JobAnalysisDetailScreen extends StatefulWidget {
  final String analysisId;

  const JobAnalysisDetailScreen({super.key, required this.analysisId});

  @override
  State<JobAnalysisDetailScreen> createState() =>
      _JobAnalysisDetailScreenState();
}

class _JobAnalysisDetailScreenState extends State<JobAnalysisDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Details'),
      ),
      body: BlocBuilder<AiJobBloc, AiJobState>(
        builder: (context, state) {
          return switch (state) {
            AiJobInitial() => const SizedBox.shrink(),
            AiJobAnalyzing() => const _DetailShimmer(),
            AiJobLoaded(:final analysis) => _buildContent(analysis),
            AiJobAnalysesLoaded() => const SizedBox.shrink(),
            AiJobError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () {},
              ),
          };
        },
      ),
    );
  }

  Widget _buildContent(JobAnalysis analysis) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (analysis.jobTitle != null)
          Text(
            analysis.jobTitle!,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        Text(
          'Analyzed on ${DateFormat('MMM dd, yyyy').format(analysis.analyzedAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (analysis.matchScore > 0) ...[
          const SizedBox(height: 20),
          _buildScoreSection(analysis.matchScore),
        ],
        const SizedBox(height: 24),
        _buildSection(theme, 'Required Skills', analysis.requiredSkills,
            AppColors.primary),
        const SizedBox(height: 20),
        _buildSection(theme, 'Preferred Skills', analysis.preferredSkills,
            AppColors.secondary),
        if (analysis.experienceRequired.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Experience Required',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.business_center,
                      color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(analysis.experienceRequired),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (analysis.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSection(theme, 'Missing Skills', analysis.missingSkills,
              AppColors.warning),
        ],
        if (analysis.recommendations.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Recommendations',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...analysis.recommendations.map(
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
        ],
        const SizedBox(height: 24),
        Text(
          'Original Description',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              analysis.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildScoreSection(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Text(
                  '${score.round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('Match Score',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSection(
      ThemeData theme, String title, List<String> items, Color chipColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: items
              .map((item) => Chip(
                    label: Text(item),
                    backgroundColor: chipColor.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();
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
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(5, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 160,
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
