import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/interview_result.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_event.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class InterviewResultScreen extends StatefulWidget {
  final String sessionId;

  const InterviewResultScreen({super.key, required this.sessionId});

  @override
  State<InterviewResultScreen> createState() => _InterviewResultScreenState();
}

class _InterviewResultScreenState extends State<InterviewResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InterviewBloc>().add(LoadInterviewResult(widget.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Results'),
      ),
      body: BlocBuilder<InterviewBloc, InterviewState>(
        builder: (context, state) {
          return switch (state) {
            InterviewInitial() => const SizedBox.shrink(),
            InterviewLoading() => const _ResultShimmer(),
            InterviewResultLoaded(:final result, :final session) =>
              _buildContent(result, session),
            InterviewSessionsLoaded() => const SizedBox.shrink(),
            InterviewSessionLoaded() => const SizedBox.shrink(),
            InterviewAnswerSubmitting() => const SizedBox.shrink(),
            InterviewGenerated() => const SizedBox.shrink(),
            InterviewError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () => context
                    .read<InterviewBloc>()
                    .add(LoadInterviewResult(widget.sessionId)),
              ),
          };
        },
      ),
    );
  }

  Widget _buildContent(InterviewResult result, InterviewSession session) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              Text(
                session.companyName,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                session.role,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildOverallScore(result.overallScore),
        const SizedBox(height: 36),
        _buildSectionHeader(theme, 'Category Scores'),
        const SizedBox(height: 12),
        ...result.categoryScores.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildCategoryBar(entry.key, entry.value),
          ),
        ),
        const SizedBox(height: 28),
        _buildSectionHeader(theme, 'Strengths'),
        const SizedBox(height: 8),
        ...result.strengths.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      size: 16, color: AppColors.success),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (result.improvementAreas.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Improvement Areas',
              color: AppColors.warning),
          const SizedBox(height: 8),
          ...result.improvementAreas.map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle,
                      size: 8, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      i,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (result.summary.isNotEmpty) ...[
          const SizedBox(height: 28),
          _buildSectionHeader(theme, 'Summary'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.summarize,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.summary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
        SafeArea(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => _backToSessions(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Sessions'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _practiceAgain(),
                icon: const Icon(Icons.refresh),
                label: const Text('Practice Again'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, {Color? color}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildOverallScore(double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: score / 100),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
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
                        valueColor: AlwaysStoppedAnimation(color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).round()}%',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                        ),
                        Text(
                          'Overall Score',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  score >= 80
                      ? 'Excellent!'
                      : score >= 50
                          ? 'Good Progress'
                          : 'Needs Practice',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar(String category, double score) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.fiber_manual_record, size: 10, color: color),
                const SizedBox(width: 8),
                Text(category,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Text('${score.round()}%',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 10,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  void _backToSessions() {
    context.go('/ai/interview/sessions');
  }

  void _practiceAgain() {
    context.go('/ai/interview/sessions');
  }
}

class _ResultShimmer extends StatelessWidget {
  const _ResultShimmer();

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
        const SizedBox(height: 12),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 24,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),
        ...List.generate(
            3,
            (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        const SizedBox(height: 24),
        ...List.generate(
            3,
            (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                )),
      ],
    );
  }
}
