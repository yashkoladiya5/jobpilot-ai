import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(const LoadJobs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applications'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.jobCreateRoute),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<JobBloc>().add(const LoadJobs());
        },
        child: BlocConsumer<JobBloc, JobState>(
          listener: (context, state) {
            if (state is JobOperationSuccess) {
              context.read<JobBloc>().add(const LoadJobs());
            }
          },
          builder: (context, state) {
            return switch (state) {
              JobInitial() => const SizedBox.shrink(),
              JobLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              JobsLoaded(:final jobs) => _buildJobsList(context, jobs),
              JobOperationSuccess() => const SizedBox.shrink(),
              JobDetailLoaded() => const SizedBox.shrink(),
              JobError(:final message) => ErrorDisplay(
                  message: message,
                  onRetry: () =>
                      context.read<JobBloc>().add(const LoadJobs()),
                ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildJobsList(BuildContext context, List<JobApplication> jobs) {
    if (jobs.isEmpty) {
      return const EmptyState(
        icon: Icons.work_outline,
        message: 'No job applications yet\nTap + to add one',
        actionLabel: 'Add Job',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Dismissible(
          key: Key(job.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            color: Colors.red.shade400,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<JobBloc>().add(DeleteJob(job.id));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  job.companyName.isNotEmpty
                      ? job.companyName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                job.companyName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.role),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(job.appliedDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              trailing: StatusChip(status: job.status),
              onTap: () =>
                  context.push('${AppConstants.jobsRoute}/${job.id}'),
            ),
          ),
        );
      },
    );
  }
}
