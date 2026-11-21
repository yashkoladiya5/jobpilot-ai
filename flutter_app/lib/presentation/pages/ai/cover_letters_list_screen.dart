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
  String _selectedToneFilter = 'All';

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
              final bloc = context.read<CoverLetterBloc>();
              await bloc.stream.firstWhere(
                (s) => s is CoverLettersLoaded || s is CoverLetterError,
              );
              bloc.add(const LoadCoverLetters());
              await bloc.stream.firstWhere(
                (s) => s is CoverLettersLoaded || s is CoverLetterError,
              );
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
      return EmptyState(
        icon: Icons.mark_email_unread_outlined,
        message: 'No AI Cover Letters Found',
        subtitle:
            'Stand out from the crowd! Generate a highly personalized cover letter tailored specifically to your resume and target job.',
        actionLabel: 'Generate New Letter',
        onAction: () => context.push('/ai/cover-letter'),
      );
    }

    final filtered = _selectedToneFilter == 'All'
        ? letters
        : letters
            .where((l) =>
                l.tone.toLowerCase() == _selectedToneFilter.toLowerCase())
            .toList();

    return Column(
      children: [
        _buildStatsHeader(letters),
        _buildToneFilterChips(letters),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.filter_list_off,
                          size: 44, color: AppColors.textHint),
                      const SizedBox(height: 12),
                      Text(
                        'No $_selectedToneFilter tone cover letters',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => _selectedToneFilter = 'All'),
                        child: const Text('Reset Filter'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 88),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _buildLetterCard(filtered[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader(List<CoverLetter> letters) {
    final completedCount =
        letters.where((l) => l.status == 'COMPLETED').length;
    final toneMap = <String, int>{};
    for (final l in letters) {
      toneMap[l.tone.toLowerCase()] = (toneMap[l.tone.toLowerCase()] ?? 0) + 1;
    }
    String topTone = 'None';
    int maxToneCount = 0;
    toneMap.forEach((tone, count) {
      if (count > maxToneCount) {
        maxToneCount = count;
        topTone = _capitalize(tone);
      }
    });

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Cover Letter Vault',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$completedCount/${letters.length} Ready',
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Top Tone: $topTone  •  Tailored for targeted job applications',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToneFilterChips(List<CoverLetter> letters) {
    final tones = ['All', 'Professional', 'Enthusiastic', 'Formal', 'Casual'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: tones.map((tone) {
          final isSelected = _selectedToneFilter == tone;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tone),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedToneFilter = tone);
                }
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
          );
        }).toList(),
      ),
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
                width: 50,
                height: 50,
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
