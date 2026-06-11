import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class ResumeAnalysisScreen extends StatefulWidget {
  final String resumeId;

  const ResumeAnalysisScreen({super.key, required this.resumeId});

  @override
  State<ResumeAnalysisScreen> createState() => _ResumeAnalysisScreenState();
}

class _ResumeAnalysisScreenState extends State<ResumeAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AiResumeBloc>().add(LoadResumeAnalysis(widget.resumeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
      ),
      body: BlocBuilder<AiResumeBloc, AiResumeState>(
        builder: (context, state) {
          return switch (state) {
            AiResumeInitial() => _buildEmptyState(),
            AiResumeAnalyzing() => const _AnalysisShimmer(),
            AiResumeLoaded(:final analysis) => RefreshIndicator(
                onRefresh: () async {
                  context.read<AiResumeBloc>()
                      .add(LoadResumeAnalysis(widget.resumeId));
                },
                child: _buildContent(analysis),
              ),
            AiResumeAnalysesLoaded() => const SizedBox.shrink(),
            AiResumeError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () => context.read<AiResumeBloc>()
                    .add(LoadResumeAnalysis(widget.resumeId)),
              ),
          };
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Analysis Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Run an AI-powered analysis to get ATS scoring\nand personalized resume feedback.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<AiResumeBloc, AiResumeState>(
      builder: (context, state) {
        if (state is AiResumeLoaded || state is AiResumeAnalyzing) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => context.read<AiResumeBloc>()
                  .add(AnalyzeResume(widget.resumeId)),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analyze Now'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ResumeAnalysis analysis) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScoreCircle(analysis.atsScore),
        const SizedBox(height: 28),
        _buildSectionHeader(theme, 'Strengths', Icons.check_circle_outline),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: analysis.strengths.map((s) => Chip(
            avatar: const Icon(Icons.check_circle, size: 18, color: AppColors.success),
            label: Text(s, style: const TextStyle(fontSize: 13)),
            backgroundColor: AppColors.success.withValues(alpha: 0.1),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          )).toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Weaknesses', Icons.warning_amber_outlined),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: analysis.weaknesses.map((w) => Chip(
            avatar: const Icon(Icons.warning_amber, size: 18, color: AppColors.error),
            label: Text(w, style: const TextStyle(fontSize: 13)),
            backgroundColor: AppColors.error.withValues(alpha: 0.1),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          )).toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Missing Keywords', Icons.highlight_off_outlined),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: analysis.missingKeywords.map((k) => Chip(
            label: Text(k, style: const TextStyle(fontSize: 13)),
            backgroundColor: Colors.transparent,
            side: BorderSide(color: AppColors.warning.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          )).toList(),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader(theme, 'Suggestions', Icons.lightbulb_outline),
        const SizedBox(height: 10),
        ...analysis.suggestions.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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
        const SizedBox(height: 20),
        _buildInfoCard(
          icon: Icons.work_history,
          title: 'Experience Summary',
          content: analysis.experienceSummary,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.psychology,
          title: 'Skills Summary',
          content: analysis.skillsSummary,
        ),
        const SizedBox(height: 12),
        _buildFeedbackCard(analysis.recruiterFeedback),
        const SizedBox(height: 20),
        Text(
          'Analyzed on ${DateFormat('MMM dd, yyyy').format(analysis.createdAt)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
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

  Widget _buildScoreCircle(int score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;
    return Center(
      child: SizedBox(
        width: 190,
        height: 190,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return SizedBox(
                  width: 190,
                  height: 190,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 14,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(color),
                    strokeCap: StrokeCap.round,
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ATS Score',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String feedback) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.primary.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: 28,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recruiter Feedback',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feedback,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisShimmer extends StatelessWidget {
  const _AnalysisShimmer();

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
              width: 190,
              height: 190,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ...List.generate(6, (_) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 80,
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
