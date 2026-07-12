import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_event.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class CoverLettersListScreen extends StatefulWidget {
  const CoverLettersListScreen({super.key});

  @override
  State<CoverLettersListScreen> createState() => _CoverLettersListScreenState();
}

class _CoverLettersListScreenState extends State<CoverLettersListScreen> {
  List<CoverLetter>? _cachedLetters;

  @override
  void initState() {
    super.initState();
    context.read<CoverLetterBloc>().add(const LoadCoverLetters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover Letters'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ai/cover-letter'),
        icon: const Icon(Icons.add),
        label: const Text('New Cover Letter'),
      ),
      body: BlocConsumer<CoverLetterBloc, CoverLetterState>(
        listener: (context, state) {
          if (state is CoverLetterLoaded) {
            context.push('/ai/cover-letter');
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CoverLetterBloc>().add(const LoadCoverLetters());
            },
            child: switch (state) {
              CoverLetterInitial() => const SizedBox.shrink(),
              CoverLetterGenerating() => _cachedLetters != null
                  ? _buildList(_cachedLetters!)
                  : const _CoverLettersShimmer(),
              CoverLettersLoaded(:final coverLetters) =>
                _buildList(_cachedLetters = coverLetters),
              CoverLetterLoaded() => _cachedLetters != null
                  ? _buildList(_cachedLetters!)
                  : const _CoverLettersShimmer(),
              CoverLetterError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () => context
                      .read<CoverLetterBloc>()
                      .add(const LoadCoverLetters()),
                ),
            },
          );
        },
      ),
    );
  }

  Widget _buildList(List<CoverLetter> letters) {
    if (letters.isEmpty) {
      return const EmptyState(
        icon: Icons.mail_outline,
        message:
            'No cover letters yet.\nGenerate your first AI-tailored cover letter!',
        actionLabel: 'Generate Cover Letter',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      itemCount: letters.length,
      itemBuilder: (context, index) => _buildLetterCard(letters[index]),
    );
  }

  Widget _buildLetterCard(CoverLetter letter) {
    final theme = Theme.of(context);
    final toneColor = _toneColor(letter.tone);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          context.read<CoverLetterBloc>().add(LoadCoverLetter(letter.id));
          context.push('/ai/cover-letter');
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
                  color: toneColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  letter.status == 'COMPLETED'
                      ? Icons.mail
                      : letter.status == 'PROCESSING'
                          ? Icons.hourglass_top
                          : Icons.error_outline,
                  color: toneColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      letter.resumeFileName.isNotEmpty
                          ? letter.resumeFileName
                          : 'Cover Letter',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_capitalize(letter.tone)} tone',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      letter.coverLetterText.isNotEmpty
                          ? letter.coverLetterText
                          : 'Generating...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusBadge(letter.status),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd').format(letter.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
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

  Color _toneColor(String tone) {
    switch (tone) {
      case 'professional':
        return AppColors.primary;
      case 'enthusiastic':
        return AppColors.warning;
      case 'formal':
        return AppColors.secondary;
      case 'casual':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'COMPLETED':
        color = AppColors.success;
        label = 'Ready';
        break;
      case 'PROCESSING':
        color = AppColors.warning;
        label = 'Generating';
        break;
      default:
        color = AppColors.error;
        label = 'Failed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CoverLettersShimmer extends StatelessWidget {
  const _CoverLettersShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(
        4,
        (_) => Padding(
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
        ),
      ),
    );
  }
}
