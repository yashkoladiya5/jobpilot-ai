import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_event.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_state.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';


enum CoverLetterTone {
  professional('Professional', 'professional'),
  enthusiastic('Enthusiastic', 'enthusiastic'),
  formal('Formal', 'formal'),
  casual('Casual', 'casual');

  const CoverLetterTone(this.label, this.value);
  final String label;
  final String value;
}

class CoverLetterScreen extends StatefulWidget {
  const CoverLetterScreen({super.key});

  @override
  State<CoverLetterScreen> createState() => _CoverLetterScreenState();
}

class _CoverLetterScreenState extends State<CoverLetterScreen> {
  final _descriptionController = TextEditingController();
  final _jobUrlController = TextEditingController();
  Resume? _selectedResume;
  CoverLetterTone _selectedTone = CoverLetterTone.professional;
  String? _generatedText;

  @override
  void initState() {
    super.initState();
    context.read<ResumeBloc>().add(const LoadResumes());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _jobUrlController.dispose();
    super.dispose();
  }

  void _generate() {
    if (_selectedResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a resume first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a job description.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedResume != null &&
        _descriptionController.text.trim().isNotEmpty) {
      context.read<CoverLetterBloc>().add(
        GenerateCoverLetter(
          _selectedResume!.id,
          _descriptionController.text.trim(),
          jobId: _jobUrlController.text.trim().isEmpty
              ? null
              : _jobUrlController.text.trim(),
          tone: _selectedTone.value,
        ),
      );
    }
  }

  void _clearForm() {
    _descriptionController.clear();
    _jobUrlController.clear();
    setState(() {
      _generatedText = null;
      _selectedTone = CoverLetterTone.professional;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cover letter copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cover letter copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<String> _extractHighlights(String text) {
    final highlights = <String>[];
    final lines = text.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('•') ||
          trimmed.startsWith('-') ||
          trimmed.startsWith('*')) {
        final cleaned = trimmed.replaceFirst(RegExp(r'^[\s•\-\*]+'), '');
        if (cleaned.length > 10 && cleaned.length < 120) {
          highlights.add(cleaned);
        }
      }
    }
    return highlights.take(6).toList();
  }

  int _wordCount(String text) {
    return text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cover Letter Generator'),
        actions: [
          if (_generatedText != null)
            IconButton(
              onPressed: _clearForm,
              icon: const Icon(Icons.refresh),
              tooltip: 'Generate new',
            ),
        ],
      ),
      body: BlocBuilder<ResumeBloc, ResumeState>(
        builder: (context, resumeState) {
          final resumes = resumeState.maybeWhen(
            resumesLoaded: (r) => r,
            orElse: () => <Resume>[],
          );

          return BlocConsumer<CoverLetterBloc, CoverLetterState>(
            listener: (context, state) {
              if (state is CoverLetterLoaded) {
                setState(() =>
                    _generatedText = state.coverLetter.coverLetterText);
              }
            },
            builder: (context, state) {
              return switch (state) {
                CoverLetterInitial() =>
                  _buildForm(theme, resumes),
                CoverLetterGenerating() =>
                  const _CoverLetterShimmer(),
                CoverLetterLoaded(:final coverLetter) =>
                  _buildResult(theme, resumes, coverLetter.coverLetterText),
                CoverLettersLoaded() =>
                  _buildForm(theme, resumes),
                CoverLetterError(:final message) =>
                  ErrorDisplay(
                    message: message,
                    onRetry: _generate,
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
    return BlocBuilder<CoverLetterBloc, CoverLetterState>(
      builder: (context, state) {
        final isLoading = state is CoverLetterGenerating;
        final hasResult = state is CoverLetterLoaded;
        final canGenerate = _selectedResume != null &&
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
                      label: const Text('Generate Another'),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: canGenerate && !isLoading ? _generate : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_awesome, size: 20),
                      label:
                          Text(isLoading ? 'Generating...' : 'Generate'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(ThemeData theme, List<Resume> resumes,
      [String? generatedText]) {
    _selectedResume ??= resumes.isNotEmpty ? resumes.first : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Select a resume and provide a job description to generate a tailored cover letter.',
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
          'Tone',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CoverLetterTone>(
          initialValue: _selectedTone,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.tune),
          ),
          items: CoverLetterTone.values.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(t.label),
            );
          }).toList(),
          onChanged: (t) {
            if (t != null) setState(() => _selectedTone = t);
          },
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
        const SizedBox(height: 20),
        Text(
          'Job URL (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _jobUrlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.link),
            hintText: 'https://...',
          ),
        ),
        if (generatedText != null) ...[
          const SizedBox(height: 24),
          _buildCoverLetterResult(theme, generatedText),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResult(
      ThemeData theme, List<Resume> resumes, String coverLetterText) {
    _generatedText = coverLetterText;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Select a resume and provide a job description to generate a tailored cover letter.',
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
          'Tone',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CoverLetterTone>(
          initialValue: _selectedTone,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.tune),
          ),
          items: CoverLetterTone.values.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(t.label),
            );
          }).toList(),
          onChanged: (t) {
            if (t != null) setState(() => _selectedTone = t);
          },
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
        const SizedBox(height: 20),
        Text(
          'Job URL (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _jobUrlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.link),
            hintText: 'https://...',
          ),
        ),
        const SizedBox(height: 24),
        _buildCoverLetterResult(theme, coverLetterText),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCoverLetterResult(ThemeData theme, String text) {
    final highlights = _extractHighlights(text);
    final words = _wordCount(text);

    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 22, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Generated Cover Letter',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$words words',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyToClipboard(text),
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareText(text),
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.stars, size: 20, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Key Highlights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: highlights.map((h) {
                return Chip(
                  avatar: const Icon(Icons.check_circle,
                      size: 16, color: AppColors.secondary),
                  label: Text(h, style: const TextStyle(fontSize: 13)),
                  backgroundColor:
                      AppColors.secondary.withValues(alpha: 0.08),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 2),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoverLetterShimmer extends StatelessWidget {
  const _CoverLetterShimmer();

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
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 40, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 200,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 140,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ...List.generate(4, (_) => Padding(
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
