import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/interview_session.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_event.dart';
import 'package:jobpilot_ai/presentation/bloc/interview/interview_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class InterviewSessionsScreen extends StatefulWidget {
  const InterviewSessionsScreen({super.key});

  @override
  State<InterviewSessionsScreen> createState() =>
      _InterviewSessionsScreenState();
}

class _InterviewSessionsScreenState extends State<InterviewSessionsScreen> {
  List<InterviewSession>? _lastSessions;

  @override
  void initState() {
    super.initState();
    context.read<InterviewBloc>().add(const LoadInterviewSessions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Prep'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewSessionDialog(),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<InterviewBloc, InterviewState>(
        listener: (context, state) {
          if (state is InterviewGenerated) {
            context.push(
              '/ai/interview/session/${state.session.id}',
              extra: state.session,
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<InterviewBloc>().add(const LoadInterviewSessions());
            },
            child: switch (state) {
              InterviewInitial() => const SizedBox.shrink(),
              InterviewLoading() => _lastSessions != null
                  ? _buildList(_lastSessions!)
                  : const _SessionsShimmer(),
              InterviewSessionsLoaded(:final sessions) =>
                _buildList(_lastSessions = sessions),
              InterviewSessionLoaded() => _lastSessions != null
                  ? _buildList(_lastSessions!)
                  : const _SessionsShimmer(),
              InterviewAnswerSubmitting() => _lastSessions != null
                  ? _buildList(_lastSessions!)
                  : const _SessionsShimmer(),
              InterviewGenerated() => _lastSessions != null
                  ? _buildList(_lastSessions!)
                  : const _SessionsShimmer(),
              InterviewResultLoaded() => _lastSessions != null
                  ? _buildList(_lastSessions!)
                  : const _SessionsShimmer(),
              InterviewError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () =>
                      context.read<InterviewBloc>().add(const LoadInterviewSessions()),
                ),
            },
          );
        },
      ),
    );
  }

  void _showNewSessionDialog() {
    final companyController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Interview Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Icons.work),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (companyController.text.trim().isNotEmpty &&
                  roleController.text.trim().isNotEmpty) {
                context.read<InterviewBloc>().add(
                      GenerateInterview(
                        companyController.text.trim(),
                        roleController.text.trim(),
                      ),
                    );
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<InterviewSession> sessions) {
    if (sessions.isEmpty) {
      return const EmptyState(
        icon: Icons.record_voice_over,
        message: 'No interview sessions yet.\nTap + to start practicing!',
        actionLabel: 'Start Session',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(InterviewSession session) {
    final theme = Theme.of(context);
    final isCompleted = session.status == 'completed';
    final statusColor = isCompleted ? AppColors.success : AppColors.warning;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          if (isCompleted) {
            context.push('/ai/interview/result/${session.id}');
          } else {
            context.push(
              '/ai/interview/session/${session.id}',
              extra: session,
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.timer,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.companyName,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${session.answeredQuestions}/${session.totalQuestions}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (session.score != null) ...[
                          const SizedBox(width: 12),
                          const Icon(Icons.star,
                              size: 14, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '${session.score!.round()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCompleted ? 'Done' : 'In Progress',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd').format(session.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionsShimmer extends StatelessWidget {
  const _SessionsShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(4, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      )),
    );
  }
}
