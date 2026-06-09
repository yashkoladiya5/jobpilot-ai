import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/domain/repositories/job_repository.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(LoadJobDetail(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final state = context.read<JobBloc>().state;
              if (state is JobDetailLoaded) {
                context.push(
                  '${AppConstants.jobsRoute}/${state.job.id}/edit',
                  extra: state.job,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return switch (state) {
            JobInitial() => const SizedBox.shrink(),
            JobLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            JobDetailLoaded(:final job) => _buildDetailContent(context, job),
            JobError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () =>
                    context.read<JobBloc>().add(LoadJobDetail(widget.jobId)),
              ),
            JobsLoaded() => const SizedBox.shrink(),
            JobOperationSuccess() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, JobApplication job) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                job.companyName.isNotEmpty
                    ? job.companyName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              job.companyName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              job.role,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: StatusChip(status: job.status)),
          const SizedBox(height: 24),
          const Divider(),
          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Applied Date',
            DateFormat('MMMM dd, yyyy').format(job.appliedDate),
          ),
          if (job.location != null)
            _buildDetailRow(
              context,
              Icons.location_on_outlined,
              'Location',
              job.location!,
            ),
          if (job.salaryRange != null)
            _buildDetailRow(
              context,
              Icons.attach_money,
              'Salary Range',
              job.salaryRange!,
            ),
          if (job.jobUrl != null)
            _buildDetailRow(
              context,
              Icons.link,
              'Job URL',
              job.jobUrl!,
            ),
          if (job.resumeId != null)
            _buildDetailRow(
              context,
              Icons.description_outlined,
              'Resume',
              'Attached resume',
            ),
          const SizedBox(height: 16),
          if (job.notes != null && job.notes!.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              job.notes!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<JobBloc>().add(DeleteJob(job.id));
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '${AppConstants.jobsRoute}/${job.id}/edit',
                      extra: job,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
          if (job.jobUrl != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open URL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          DropdownButtonFormField<ApplicationStatus>(
            value: job.status,
            decoration: const InputDecoration(
              labelText: 'Change Status',
              prefixIcon: Icon(Icons.swap_horiz),
            ),
            items: ApplicationStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.value),
              );
            }).toList(),
            onChanged: (newStatus) {
              if (newStatus != null && newStatus != job.status) {
                context.read<JobBloc>().add(
                      UpdateJob(
                        job.id,
                        UpdateJobParams(status: newStatus),
                      ),
                    );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final state = context.read<JobBloc>().state;
              if (state is JobDetailLoaded) {
                context.read<JobBloc>().add(DeleteJob(state.job.id));
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
