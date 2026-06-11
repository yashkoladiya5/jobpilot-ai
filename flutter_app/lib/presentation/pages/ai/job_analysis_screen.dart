import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_analysis.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_job/ai_job_state.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class JobAnalysisScreen extends StatefulWidget {
  const JobAnalysisScreen({super.key});

  @override
  State<JobAnalysisScreen> createState() => _JobAnalysisScreenState();
}

class _JobAnalysisScreenState extends State<JobAnalysisScreen> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(const LoadJobs());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _analyze() {
    final text = _descriptionController.text.trim();
    if (text.isNotEmpty) {
      context.read<AiJobBloc>().add(AnalyzeJobDescription(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Job Description'),
      ),
      body: BlocConsumer<AiJobBloc, AiJobState>(
        listener: (context, state) {},
        builder: (context, state) {
          return switch (state) {
            AiJobInitial() => _buildInputForm(theme, null),
            AiJobAnalyzing() => const _JobAnalysisShimmer(),
            AiJobLoaded(:final analysis) => _buildInputForm(theme, analysis),
            AiJobAnalysesLoaded() => const SizedBox.shrink(),
            AiJobError(:final message) => ErrorDisplay(
                message: message,
                onRetry: _analyze,
              ),
          };
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<AiJobBloc, AiJobState>(
      builder: (context, state) {
        final isLoading = state is AiJobAnalyzing;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _descriptionController.text.trim().isNotEmpty && !isLoading
                  ? _analyze
                  : null,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome, size: 20),
              label: Text(isLoading ? 'Analyzing...' : 'Analyze'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputForm(ThemeData theme, JobAnalysis? analysis) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Paste a job description below to analyze its requirements and get a compatibility assessment.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<JobBloc, JobState>(
          builder: (context, jobState) {
            final jobs = jobState.maybeWhen(
              jobsLoaded: (list) => list,
              orElse: () => <JobApplication>[],
            );
            if (jobs.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Link to Saved Job',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<JobApplication>(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.work_outline),
                    hintText: 'Select a saved job...',
                  ),
                  items: jobs.map((j) => DropdownMenuItem(
                    value: j,
                    child: Text(
                      '${j.companyName} - ${j.role}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                  onChanged: (job) {
                    if (job != null) {
                      _descriptionController.text =
                          'Job Title: ${job.role}\nCompany: ${job.companyName}\n\n';
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
        Text(
          'Job Description',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 10,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Paste the full job description here...',
            alignLabelWithHint: true,
          ),
        ),
        if (analysis != null) ...[
          const SizedBox(height: 24),
          _buildResults(theme, analysis),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResults(ThemeData theme, JobAnalysis analysis) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (analysis.matchScore > 0) ...[
            Center(child: _buildMatchScore(analysis.matchScore)),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader(theme, 'Required Skills', Icons.checklist),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: analysis.requiredSkills.map((s) => Chip(
              avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
              label: Text(s, style: const TextStyle(fontSize: 13)),
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            )).toList(),
          ),
          if (analysis.preferredSkills.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Preferred Skills', Icons.star_outline),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: analysis.preferredSkills.map((s) => Chip(
                label: Text(s, style: const TextStyle(fontSize: 13)),
                backgroundColor: Colors.transparent,
                side: BorderSide(color: AppColors.secondary.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              )).toList(),
            ),
          ],
          if (analysis.missingSkills.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Missing Skills', Icons.highlight_off_outlined),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: analysis.missingSkills.map((s) => Chip(
                avatar: const Icon(Icons.warning_amber, size: 16, color: AppColors.error),
                label: Text(s, style: const TextStyle(fontSize: 13)),
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              )).toList(),
            ),
          ],
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
          if (analysis.recommendations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Recommended Changes', Icons.tips_and_updates_outlined),
            const SizedBox(height: 10),
            ...analysis.recommendations.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
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
            )),
          ],
        ],
      ),
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

  Widget _buildMatchScore(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
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
    );
  }
}

class _JobAnalysisShimmer extends StatelessWidget {
  const _JobAnalysisShimmer();

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
