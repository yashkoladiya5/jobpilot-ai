import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/loading_overlay.dart';
import 'package:jobpilot_ai/presentation/widgets/resume_card.dart';
import 'package:shimmer/shimmer.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  List<Resume>? _lastResumes;

  @override
  void initState() {
    super.initState();
    context.read<ResumeBloc>().add(const LoadResumes());
  }

  Future<void> _pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final confirmed = await _showFileConfirmation(file);
    if (confirmed == true && mounted) {
      context.read<ResumeBloc>().add(UploadResume(file.path!));
    }
  }

  Future<bool?> _showFileConfirmation(PlatformFile file) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Upload Resume'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isPdf(file.name) ? Icons.picture_as_pdf : Icons.description_outlined,
                  color: _isPdf(file.name) ? AppColors.error : AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file.name,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Size: ${_formatFileSize(file.size)}',
              style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Resume resume) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resume'),
        content: Text('Are you sure you want to delete "${resume.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ResumeBloc>().add(DeleteResume(resume.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadFile,
        tooltip: 'Upload Resume',
        child: const Icon(Icons.upload_file),
      ),
      body: BlocConsumer<ResumeBloc, ResumeState>(
        listener: (context, state) {
          state.maybeWhen(
            uploadSuccess: (resume) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${resume.fileName} uploaded successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            operationSuccess: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state is ResumeLoading;
          final showOverlay = isLoading && _lastResumes != null;
          return LoadingOverlay(
            isLoading: showOverlay,
            message: showOverlay ? _loadingMessage(state) : null,
            child: state.maybeWhen(
              initial: () => const SizedBox.shrink(),
              loading: () => _lastResumes != null
                  ? _buildResumeList(_lastResumes!)
                  : const _ResumeShimmer(),
              resumesLoaded: (resumes) {
                _lastResumes = resumes;
                return _buildResumeList(resumes);
              },
              uploadSuccess: (_) => _lastResumes != null
                  ? _buildResumeList(_lastResumes!)
                  : const SizedBox.shrink(),
              operationSuccess: (_) => _lastResumes != null
                  ? _buildResumeList(_lastResumes!)
                  : const SizedBox.shrink(),
              error: (message) => ErrorDisplay(
                message: message,
                onRetry: () => context.read<ResumeBloc>().add(const LoadResumes()),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  String _loadingMessage(ResumeLoading state) {
    return 'Please wait...';
  }

  Widget _buildResumeList(List<Resume> resumes) {
    if (resumes.isEmpty) {
      return const EmptyState(
        icon: Icons.description_outlined,
        message: 'No resumes yet.\nUpload your first resume!',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResumeBloc>().add(const LoadResumes());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: resumes.length,
        itemBuilder: (context, index) {
          final resume = resumes[index];
          return Dismissible(
            key: ValueKey(resume.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
            confirmDismiss: (direction) async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Resume'),
                  content: Text(
                    'Are you sure you want to delete "${resume.fileName}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              return shouldDelete ?? false;
            },
            onDismissed: (_) {
              context.read<ResumeBloc>().add(DeleteResume(resume.id));
            },
            child: ResumeCard(
              resume: resume,
              onDelete: () => _confirmDelete(resume),
              onTap: () => context.read<ResumeBloc>().add(SetPrimaryResume(resume.id)),
            ),
          );
        },
      ),
    );
  }

  bool _isPdf(String fileName) {
    return fileName.toLowerCase().endsWith('.pdf');
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _ResumeShimmer extends StatelessWidget {
  const _ResumeShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 88),
      children: List.generate(3, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 72,
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
