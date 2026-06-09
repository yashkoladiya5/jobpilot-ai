import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';

class ResumeCard extends StatelessWidget {
  final Resume resume;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ResumeCard({
    super.key,
    required this.resume,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = resume.isPrimary ?? false;
    final mimeType = resume.mimeType?.toLowerCase() ?? '';
    final isPdf = mimeType.contains('pdf');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              _buildFileIcon(isPdf, theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resume.fileName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buildSubtitle(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isPrimary)
                _buildPrimaryBadge(theme)
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onTap,
                      icon: const Icon(Icons.star_border),
                      color: AppColors.warning,
                      tooltip: 'Set as primary',
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.error,
                      tooltip: 'Delete resume',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(bool isPdf, ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPdf
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isPdf ? Icons.picture_as_pdf : Icons.description_outlined,
        color: isPdf ? AppColors.error : AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildPrimaryBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 14,
            color: AppColors.success,
          ),
          const SizedBox(width: 4),
          Text(
            'Primary',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    final size = _formatFileSize(resume.fileSize);
    if (size.isNotEmpty) parts.add(size);
    if (resume.createdAt != null) {
      parts.add(DateFormat('MMM dd, yyyy').format(resume.createdAt!));
    }
    return parts.join(' · ');
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
