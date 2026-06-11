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
  MatchResult? _lastResult;

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

  void _match() {
    if (_selectedResume != null && _descriptionController.text.trim().isNotEmpty) {
      context.read<AiMatchBloc>().add(
        MatchResumeToJob(
          _selectedResume!.id,
          _descriptionController.text.trim(),
        ),
      );
    }
  }

  void _clearForm() {
    _descriptionController.clear();
    setState(() => _lastResult = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Matching'),
        actions: [
          if (_lastResult != null)
            IconButton(
              onPressed: _clearForm,
              icon: const Icon(Icons.refresh),
              tooltip: 'Clear form',
            ),
        ],
      ),
      body: BlocBuilder<ResumeBloc, ResumeState>(
        builder: (context, resumeState) {
          final resumes = resumeState.maybeWhen(
            resumesLoaded: (r) => r,
            orElse: () => <Resume>[],
          );

          return BlocConsumer<AiMatchBloc, AiMatchState>(
            listener: (context, matchState) {
              if (matchState is AiMatchLoaded) {
                setState(() => _lastResult = matchState.result);
              }
            },
            builder: (context, matchState) {
              return switch (matchState) {
                AiMatchInitial() => _buildForm(theme, resumes),
                AiMatchMatching() => const _MatchingShimmer(),
                AiMatchLoaded(:final result) => _buildForm(theme, resumes, result),
                AiMatchError(:final message) => ErrorDisplay(
                    message: message,
                    onRetry: _match,
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
    return BlocBuilder<AiMatchBloc, AiMatchState>(
      builder: (context, state) {
        final isLoading = state is AiMatchMatching;
        final hasResult = state is AiMatchLoaded;
        final canMatch = _selectedResume != null &&
            _descriptionController.text.trim().isNotEmpty;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (hasResult)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearForm,
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text('Match Another'),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: canMatch && !isLoading ? _match : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.compare_arrows, size: 20),
                      label: Text(isLoading ? 'Matching...' : 'Match'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(ThemeData theme, List<Resume> resumes, [MatchResult? result]) {
    _selectedResume ??= resumes.isNotEmpty ? resumes.first : null;
    if (result != null) _lastResult = result;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Select a resume and paste a job description to check compatibility.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Select Resume',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Resume>(
          initialValue: _selectedResume,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.description),
          ),
          items: resumes.map((r) {
            return DropdownMenuItem(
              value: r,
              child: Text(
                r.fileName,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (r) => setState(() => _selectedResume = r),
        ),
        const SizedBox(height: 20),
        Text(
          'Job Description',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 8,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Paste the full job description here...',
            alignLabelWithHint: true,
          ),
        ),
        if (_lastResult != null) ...[
          const SizedBox(height: 24),
          _buildResults(theme, _lastResult!),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResults(ThemeData theme, MatchResult result) {
    final scoreColor = result.matchScore >= 80
        ? AppColors.success
        : result.matchScore >= 50
            ? AppColors.warning
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: result.matchScore / 100),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 14,
                            backgroundColor: AppColors.divider,
                            valueColor: AlwaysStoppedAnimation(scoreColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(value * 100).round()}%',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Match Score',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        if (result.matchedSkills.isNotEmpty) ...[
          _buildSectionHeader(theme, 'Matched Skills', Icons.check_circle_outline, AppColors.success),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.matchedSkills.map((s) => Chip(
              avatar: const Icon(Icons.check_circle, size: 18, color: AppColors.success),
              label: Text(s, style: const TextStyle(fontSize: 13)),
              backgroundColor: AppColors.success.withValues(alpha: 0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            )).toList(),
          ),
        ],
        if (result.missingSkills.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Missing Skills', Icons.highlight_off_outlined, AppColors.error),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.missingSkills.map((s) => Chip(
              avatar: const Icon(Icons.warning_amber, size: 18, color: AppColors.error),
              label: Text(s, style: const TextStyle(fontSize: 13)),
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            )).toList(),
          ),
        ],
        if (result.priorityImprovements.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Priority Improvements', Icons.priority_high_outlined, AppColors.warning),
          const SizedBox(height: 10),
          ...result.priorityImprovements.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.priority_high, size: 16, color: AppColors.warning),
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
        if (result.interviewRiskAreas.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Interview Risk Areas', Icons.warning_amber_outlined, AppColors.warning),
          const SizedBox(height: 10),
          ...result.interviewRiskAreas.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              margin: EdgeInsets.zero,
              color: AppColors.warning.withValues(alpha: 0.04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.warning.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber, size: 20, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        r,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
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
              width: 180,
              height: 180,
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
                  height: 60,
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
