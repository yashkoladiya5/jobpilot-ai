import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/match_result.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_match/ai_match_state.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final _descriptionController = TextEditingController();
  Resume? _selectedResume;

  @override
  void initState() {
    super.initState();
    context.read<ResumeBloc>().add(const LoadResumes());
  }

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
        title: const Text('Resume Matching'),
      ),
      body: BlocBuilder<ResumeBloc, ResumeState>(
        builder: (context, resumeState) {
          final resumes = resumeState.maybeWhen(
            resumesLoaded: (r) => r,
            orElse: () => <Resume>[],
          );

          return BlocBuilder<AiMatchBloc, AiMatchState>(
            builder: (context, matchState) {
              return switch (matchState) {
                AiMatchInitial() => _buildForm(theme, resumes),
                AiMatchMatching() => const _MatchingShimmer(),
                AiMatchLoaded(:final result) => _buildForm(theme, resumes, result),
                AiMatchError(:final message) => ErrorDisplay(
                    message: message,
                    onRetry: () {},
                  ),
              };
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final hasResult = context.read<AiMatchBloc>().state is AiMatchLoaded;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _selectedResume != null &&
                  _descriptionController.text.trim().isNotEmpty &&
                  !hasResult
              ? () {
                  context.read<AiMatchBloc>().add(
                        MatchResumeToJob(
                          _selectedResume!.id,
                          _descriptionController.text.trim(),
                        ),
                      );
                }
              : null,
          child: const Text('Match'),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, List<Resume> resumes, [MatchResult? result]) {
    _selectedResume ??= resumes.isNotEmpty ? resumes.first : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Select a resume and paste a job description to check compatibility',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Text('Select Resume',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Resume>(
          initialValue: _selectedResume,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.description),
          ),
          items: resumes.map((r) {
            return DropdownMenuItem(
              value: r,
              child: Text(r.fileName),
            );
          }).toList(),
          onChanged: (r) => setState(() => _selectedResume = r),
        ),
        const SizedBox(height: 20),
        Text('Job Description',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'Paste job description here...',
            alignLabelWithHint: true,
          ),
        ),
        if (result != null) ...[
          const SizedBox(height: 24),
          _buildResults(theme, result),
        ],
      ],
    );
  }

  Widget _buildResults(ThemeData theme, MatchResult result) {
    final scoreColor = result.matchScore >= 80
        ? AppColors.success
        : result.matchScore >= 60
            ? AppColors.warning
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
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
                        value: result.matchScore / 100,
                        strokeWidth: 12,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation(scoreColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${result.matchScore.round()}%',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                        Text(
                          'Match Score',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (result.matchedSkills.isNotEmpty) ...[
          Text('Matched Skills',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: result.matchedSkills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor:
                          AppColors.success.withValues(alpha: 0.12),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],
        if (result.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Missing Skills',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              )),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: result.missingSkills
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor:
                          AppColors.error.withValues(alpha: 0.12),
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],
        if (result.priorityImprovements.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Priority Improvements',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...result.priorityImprovements.map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.priority_high,
                      size: 18, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(child: Text(i)),
                ],
              ),
            ),
          ),
        ],
        if (result.interviewRiskAreas.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Interview Risk Areas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              )),
          const SizedBox(height: 8),
          ...result.interviewRiskAreas.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber,
                      size: 18, color: AppColors.warning),
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
}

class _MatchingShimmer extends StatelessWidget {
  const _MatchingShimmer();
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
        ...List.generate(4, (_) => Padding(
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
                      height: 40,
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
