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

class JobsKanbanView extends StatelessWidget {
  final List<JobApplication> jobs;

  const JobsKanbanView({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    const columns = [
      ApplicationStatus.saved,
      ApplicationStatus.applied,
      ApplicationStatus.interview,
      ApplicationStatus.offer,
      ApplicationStatus.rejected,
    ];

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      children: columns.map((status) {
        final columnJobs = jobs.where((j) => j.status == status).toList();
        return _buildKanbanColumn(context, status, columnJobs);
      }).toList(),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    ApplicationStatus status,
    List<JobApplication> columnJobs,
  ) {
    final statusColor = _statusColor(status);
    final statusTitle = status.value[0] + status.value.substring(1).toLowerCase();

    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${columnJobs.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: DragTarget<JobApplication>(
              onWillAcceptWithDetails: (details) => details.data.status != status,
              onAcceptWithDetails: (details) {
                final job = details.data;
                context.read<JobBloc>().add(
                  UpdateJob(job.id, UpdateJobParams(status: status)),
                );
              },
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty;
                return Container(
                  color: isHovered
                      ? statusColor.withValues(alpha: 0.08)
                      : Colors.transparent,
                  child: columnJobs.isEmpty
                      ? Center(
                          child: Text(
                            'Drag here to move to $statusTitle',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: columnJobs.length,
                          itemBuilder: (context, idx) {
                            final job = columnJobs[idx];
                            return _buildDraggableJobCard(context, job);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableJobCard(BuildContext context, JobApplication job) {
    return LongPressDraggable<JobApplication>(
      data: job,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                job.companyName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                job.role,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _buildCardContent(context, job),
      ),
      child: _buildCardContent(context, job),
    );
  }

  Widget _buildCardContent(BuildContext context, JobApplication job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('${AppConstants.jobsRoute}/${job.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.companyName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (job.isFavorite)
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                job.role,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (job.location != null) ...[
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        job.location!,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  Text(
                    DateFormat('MMM d').format(job.appliedDate),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return AppColors.warning;
      case ApplicationStatus.applied:
        return AppColors.primary;
      case ApplicationStatus.interview:
        return AppColors.secondary;
      case ApplicationStatus.offer:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.error;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }
}
