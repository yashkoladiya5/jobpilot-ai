import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class JobAnalysisScreen extends StatefulWidget {
  const JobAnalysisScreen({super.key});

  @override
  State<JobAnalysisScreen> createState() => _JobAnalysisScreenState();
}

class _JobAnalysisScreenState extends State<JobAnalysisScreen> {
  final _descriptionController = TextEditingController();
  JobAnalysis? _lastResult;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Job Description'),
      ),
      body: BlocConsumer<AiJobBloc, AiJobState>(
        listener: (context, state) {
          if (state is AiJobLoaded) {
            setState(() => _lastResult = state.analysis);
          }
        },
        builder: (context, state) {
          return switch (state) {
            AiJobInitial() => _buildInputForm(theme, null),
            AiJobAnalyzing() => const _JobAnalysisShimmer(),
            AiJobLoaded(:final analysis) => _buildInputForm(theme, analysis),
            AiJobAnalysesLoaded() => const SizedBox.shrink(),
            AiJobError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () {},
              ),
          };
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _lastResult == null
              ? () {
                  if (_descriptionController.text.trim().isNotEmpty) {
                    context.read<AiJobBloc>().add(
                          AnalyzeJobDescription(
                            _descriptionController.text.trim(),
                          ),
                        );
                  }
                }
              : null,
          child: const Text('Analyze'),
        ),
      ),
    );
  }

  Widget _buildInputForm(ThemeData theme, JobAnalysis? analysis) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Paste a job description to analyze its requirements',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: 'Paste job description here...',
            alignLabelWithHint: true,
          ),
        ),
        if (analysis != null) ...[
          const SizedBox(height: 24),
          _buildResults(theme, analysis),
        ],
      ],
    );
  }

  Widget _buildResults(ThemeData theme, JobAnalysis analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (analysis.matchScore > 0) ...[
          Center(
            child: _buildMatchScore(analysis.matchScore),
          ),
          const SizedBox(height: 20),
        ],
        Text('Required Skills',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: analysis.requiredSkills
              .map((s) => Chip(
                    label: Text(s),
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    side: BorderSide.none,
                  ))
              .toList(),
        ),
        if (analysis.preferredSkills.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Preferred Skills',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: analysis.preferredSkills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor:
                          AppColors.secondary.withValues(alpha: 0.1),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],
        if (analysis.experienceRequired.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildInfoRow(
              Icons.business_center, 'Experience', analysis.experienceRequired),
        ],
        if (analysis.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Missing Skills',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.warning)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: analysis.missingSkills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor:
                          AppColors.warning.withValues(alpha: 0.12),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],
        if (analysis.recommendations.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Recommendations',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...analysis.recommendations.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle,
                      size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(r)),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMatchScore(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
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
                    .headlineMedium
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _JobAnalysisShimmer extends StatelessWidget {
  const _JobAnalysisShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(4, (_) => Padding(
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
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
