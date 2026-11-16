import 'dart:async';
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
  bool _isSubmitting = false;
  String _feedbackMessage = '';
  InterviewSession? _session;

  // Real-time interview simulation timer
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isVoiceRecording = false;
  bool _showStarGuide = false;

  @override
  void initState() {
    super.initState();
    context.read<InterviewBloc>().add(LoadInterviewSession(widget.sessionId));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _answerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  String _formatElapsedTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _submitAnswer() {
    final question = _session!.questions[_currentQuestionIndex];
    final answer = _answerController.text.trim();
    if (answer.isEmpty || _isSubmitting) return;

    context.read<InterviewBloc>().add(
          SubmitAnswer(widget.sessionId, question.id, answer),
        );

    setState(() {
      _isSubmitting = true;
      _showFeedback = true;
      _feedbackMessage = question.feedback ??
          'Good effort! Consider adding specific examples '
              'from your experience to strengthen your response.';
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showFeedback = false;
        _isSubmitting = false;
        if (_currentQuestionIndex < _session!.questions.length - 1) {
          _currentQuestionIndex++;
          _answerController.clear();
          _startTimer();
        }
      });
    });
  }

  void _completeInterview() {
    context
        .read<InterviewBloc>()
        .add(CompleteInterview(widget.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_session != null
            ? '${_session!.companyName} - ${_session!.role}'
            : 'Interview Session'),
      ),
      body: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewSessionLoaded) {
            _session = state.session;
            final allAnswered = _currentQuestionIndex >= state.session.questions.length;
            if (allAnswered && state.session.status == 'completed') {
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
            InterviewAnswerSubmitting() => _session != null
                ? _buildSessionContent(_session!,
                    isSubmitting: true)
                : const _SessionShimmer(),
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
    _session = session;
    final questions = session.questions;

    if (_currentQuestionIndex >= questions.length) {
      return _buildCompleteView();
    }

    final question = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;
    final hasAnswer = question.answer != null && question.answer!.isNotEmpty;
    final isLastQuestion = _currentQuestionIndex == questions.length - 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (hasAnswer)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Reviewed',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.divider,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0)
                      .animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey('question_$_currentQuestionIndex'),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      _buildCategoryBadge(question.category),
                      const SizedBox(width: 8),
                      _buildDifficultyBadge(question.difficulty),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _elapsedSeconds > 120
                              ? AppColors.error.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: _elapsedSeconds > 120 ? AppColors.error : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatElapsedTime(_elapsedSeconds),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _elapsedSeconds > 120 ? AppColors.error : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question.question,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (hasAnswer && question.answer != null) ...[
                    _buildReadOnlyAnswer(question.answer!),
                    const SizedBox(height: 16),
                    if (question.feedback != null)
                      _buildFeedbackCard(question.feedback!),
                  ] else ...[
                    // Framework hint / STAR Method prompt
                    InkWell(
                      onTap: () => setState(() => _showStarGuide = !_showStarGuide),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Interview Framework: Use STAR Method (Situation, Task, Action, Result)',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryDark),
                              ),
                            ),
                            Icon(_showStarGuide ? Icons.expand_less : Icons.expand_more, size: 16, color: AppColors.secondary),
                          ],
                        ),
                      ),
                    ),
                    if (_showStarGuide) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Situation: Set the context and specify the challenge.', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text('• Task: Describe what your responsibility was.', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text('• Action: Detail the specific steps you took to address it.', style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text('• Result: Share the measurable outcomes and what you learned.', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: _answerController,
                      maxLines: 5,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Type your answer here using the STAR method...',
                        alignLabelWithHint: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isVoiceRecording ? Icons.mic : Icons.mic_none,
                            color: _isVoiceRecording ? AppColors.error : AppColors.primary,
                          ),
                          tooltip: _isVoiceRecording ? 'Stop recording' : 'Voice simulation mode',
                          onPressed: () {
                            setState(() {
                              _isVoiceRecording = !_isVoiceRecording;
                              if (_isVoiceRecording && _answerController.text.isEmpty) {
                                _answerController.text = 'In my previous position, I led a cross-functional team to ';
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    if (_isVoiceRecording)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, color: AppColors.error, size: 12),
                            const SizedBox(width: 6),
                            Text(
                              'Voice recording active... (transcribing simulation)',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_answerController.text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length} words',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_showFeedback && _feedbackMessage.isNotEmpty &&
                      !hasAnswer) ...[
                    const SizedBox(height: 16),
                    _buildFeedbackCard(_feedbackMessage),
                    if (isLastQuestion) ...[
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _completeInterview,
                        icon: const Icon(Icons.checklist),
                        label: const Text('Complete Interview'),
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        if (!hasAnswer && !_showFeedback)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed:
                    isSubmitting || _answerController.text.trim().isEmpty
                        ? null
                        : _submitAnswer,
                child: Text(
                  isSubmitting
                      ? 'Submitting...'
                      : isLastQuestion
                          ? 'Submit Answer'
                          : 'Submit Answer',
                ),
              ),
            ),
          ),
        if (hasAnswer)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex--;
                            _answerController.clear();
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentQuestionIndex < questions.length - 1
                          ? () {
                              setState(() {
                                _currentQuestionIndex++;
                                _answerController.clear();
                              });
                            }
                          : _completeInterview,
                      icon: Icon(_currentQuestionIndex < questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.checklist),
                      label: Text(_currentQuestionIndex < questions.length - 1
                          ? 'Next'
                          : 'Complete'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompleteView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded,
                size: 96, color: AppColors.success),
            const SizedBox(height: 24),
            Text(
              'All questions answered!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Review your answers or complete\nthe interview to see your results.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _completeInterview,
              icon: const Icon(Icons.analytics),
              label: const Text('Complete & View Results'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex = 0;
                  _answerController.clear();
                });
              },
              child: const Text('Review Answers'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(String feedback) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.auto_awesome,
                    size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                'Coach Feedback',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyAnswer(String answer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rate_review,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Your Answer',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    final config = _categoryConfig(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 14, color: config.color),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    final color = _difficultyColor(difficulty);
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

  ({Color color, IconData icon}) _categoryConfig(String category) {
    switch (category.toLowerCase()) {
      case 'hr':
        return (color: const Color(0xFF1565C0), icon: Icons.people);
      case 'technical':
        return (color: const Color(0xFF7B1FA2), icon: Icons.code);
      case 'behavioral':
        return (color: const Color(0xFF2E7D32), icon: Icons.psychology);
      case 'follow-up':
        return (color: const Color(0xFFE65100), icon: Icons.reply);
      default:
        return (color: AppColors.primary, icon: Icons.help_outline);
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'hard':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }
}

class _SessionShimmer extends StatelessWidget {
  const _SessionShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 24,
                  width: 120,
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
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 140,
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
