import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_event.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class InterviewSessionScreen extends StatefulWidget {
  final String sessionId;

  const InterviewSessionScreen({super.key, required this.sessionId});

  @override
  State<InterviewSessionScreen> createState() => _InterviewSessionScreenState();
}

class _InterviewSessionScreenState extends State<InterviewSessionScreen> {
  final _answerController = TextEditingController();
  int _currentQuestionIndex = 0;
  bool _showFeedback = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Session'),
      ),
      body: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewSessionLoaded) {
            if (_currentQuestionIndex >= state.session.questions.length &&
                state.session.status == 'completed') {
              context
                  .read<InterviewBloc>()
                  .add(LoadInterviewResult(widget.sessionId));
            }
          }
          if (state is InterviewResultLoaded) {
            context.pushReplacement(
              '/ai/interview/result/${widget.sessionId}',
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            InterviewInitial() => const SizedBox.shrink(),
            InterviewLoading() => const _SessionShimmer(),
            InterviewSessionLoaded(:final session) =>
              _buildSessionContent(session),
            InterviewAnswerSubmitting() => _buildSessionContent(
                (context.read<InterviewBloc>().state
                        as InterviewSessionLoaded)
                    .session,
                isSubmitting: true,
              ),
            InterviewResultLoaded() => const SizedBox.shrink(),
            InterviewSessionsLoaded() => const SizedBox.shrink(),
            InterviewGenerated() => const SizedBox.shrink(),
            InterviewError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () => context
                    .read<InterviewBloc>()
                    .add(LoadInterviewSession(widget.sessionId)),
              ),
          };
        },
      ),
    );
  }

  Widget _buildSessionContent(InterviewSession session,
      {bool isSubmitting = false}) {
    final questions = session.questions;

    if (_currentQuestionIndex >= questions.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                size: 80, color: AppColors.success),
            const SizedBox(height: 16),
            Text(
              'All questions answered!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context
                    .read<InterviewBloc>()
                    .add(CompleteInterview(widget.sessionId));
              },
              child: const Text('Complete & View Results'),
            ),
          ],
        ),
      );
    }

    final question = questions[_currentQuestionIndex];
    final progress = _currentQuestionIndex / questions.length;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.divider,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const Spacer(),
                  _buildCategoryBadge(question.category),
                  const SizedBox(width: 8),
                  _buildDifficultyBadge(question.difficulty),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                question.question,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600, height: 1.4),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _answerController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Type your answer here...',
                  alignLabelWithHint: true,
                ),
              ),
              if (_showFeedback && question.feedback != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.feedback,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Feedback',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.feedback!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showFeedback = false;
                      _currentQuestionIndex++;
                      _answerController.clear();
                    });
                  },
                  child: Text(
                    _currentQuestionIndex + 1 < questions.length
                        ? 'Next Question'
                        : 'Review Answers',
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: isSubmitting || _answerController.text.trim().isEmpty
                  ? null
                  : () {
                      context.read<InterviewBloc>().add(
                            SubmitAnswer(
                              widget.sessionId,
                              question.id,
                              _answerController.text.trim(),
                            ),
                          );
                      setState(() => _showFeedback = true);
                    },
              child: Text(
                isSubmitting ? 'Submitting...' : 'Submit Answer',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color color;
    switch (category.toLowerCase()) {
      case 'technical':
        color = AppColors.primary;
        break;
      case 'behavioral':
        color = AppColors.secondary;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'hard':
        color = AppColors.error;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _SessionShimmer extends StatelessWidget {
  const _SessionShimmer();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinearProgressIndicator(backgroundColor: AppColors.divider),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 20,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
