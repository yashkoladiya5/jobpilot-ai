import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_bloc.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
      ),
      body: BlocBuilder<AiResumeBloc, AiResumeState>(
        builder: (context, state) {
          return switch (state) {
            AiResumeInitial() => const SizedBox.shrink(),
            AiResumeAnalyzing() => const _AnalysisShimmer(),
            AiResumeLoaded(:final analysis) => _buildContent(analysis),
            AiResumeAnalysesLoaded() => const SizedBox.shrink(),
            AiResumeError(:final message) => ErrorDisplay(
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
          onPressed: () {},
          child: const Text('Analyze Resume'),
        ),
      ),
    );
  }

  Widget _buildContent(ResumeAnalysis analysis) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildScoreCircle(analysis.atsScore),
        const SizedBox(height: 24),
        Text('Strengths',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: analysis.strengths
              .map((s) => Chip(
                    label: Text(s),
                    backgroundColor: AppColors.success.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        Text('Weaknesses',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: analysis.weaknesses
              .map((w) => Chip(
                    label: Text(w),
                    backgroundColor: AppColors.error.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        Text('Missing Keywords',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: analysis.missingKeywords
              .map((k) => Chip(
                    label: Text(k),
                    backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        _buildSection(theme, 'Suggestions', analysis.suggestions),
        const SizedBox(height: 16),
        _buildSection(theme, 'Experience Summary', [
          analysis.experienceSummary
        ]),
        const SizedBox(height: 16),
        _buildSection(theme, 'Skills Summary', [analysis.skillsSummary]),
        const SizedBox(height: 16),
        _buildSection(
            theme, 'Recruiter Feedback', [analysis.recruiterFeedback]),
        const SizedBox(height: 16),
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

  Widget _buildScoreCircle(int score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 60
            ? AppColors.warning
            : AppColors.error;
    return Center(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 12,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  'ATS Score',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      ThemeData theme, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(item, style: theme.textTheme.bodyMedium),
            )),
      ],
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
                      width: 140,
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
