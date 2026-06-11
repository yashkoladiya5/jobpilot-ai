import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_event.dart';
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
    context.read<AiJobBloc>().add(LoadJobAnalysis(widget.analysisId));
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
                onRetry: () => context.read<AiJobBloc>()
                    .add(LoadJobAnalysis(widget.analysisId)),
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
        if (analysis.jobTitle != null) ...[
          Text(
            analysis.jobTitle!,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          'Analyzed on ${DateFormat('MMM dd, yyyy').format(analysis.analyzedAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (analysis.matchScore > 0) ...[
          const SizedBox(height: 24),
          _buildScoreSection(analysis.matchScore),
        ],
        const SizedBox(height: 28),
        _buildSection(
          theme: theme,
          title: 'Required Skills',
          items: analysis.requiredSkills,
          chipColor: AppColors.primary,
          icon: Icons.check_circle,
        ),
        const SizedBox(height: 24),
        _buildSection(
          theme: theme,
          title: 'Preferred Skills',
          items: analysis.preferredSkills,
          chipColor: AppColors.secondary,
          icon: Icons.star,
        ),
        if (analysis.experienceRequired.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Experience Required', Icons.business_center),
          const SizedBox(height: 10),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.business_center, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      analysis.experienceRequired,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (analysis.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSection(
            theme: theme,
            title: 'Missing Skills',
            items: analysis.missingSkills,
            chipColor: AppColors.error,
            icon: Icons.warning_amber,
          ),
        ],
        if (analysis.recommendations.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Recommendations', Icons.tips_and_updates_outlined),
          const SizedBox(height: 10),
          ...analysis.recommendations.asMap().entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Original Description', Icons.description_outlined),
        const SizedBox(height: 10),
        Card(
          margin: EdgeInsets.zero,
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              analysis.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required List<String> items,
    required Color chipColor,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: chipColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(
            avatar: Icon(icon, size: 16, color: chipColor),
            label: Text(item, style: const TextStyle(fontSize: 13)),
            backgroundColor: chipColor.withValues(alpha: 0.08),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildScoreSection(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: score / 100),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Column(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation(color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${(value * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Match Score',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
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
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ...List.generate(5, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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
