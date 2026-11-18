import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/constants/app_constants.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_event.dart';
import 'package:jobpilot_ai/presentation/bloc/job/job_state.dart';
import 'package:jobpilot_ai/presentation/pages/jobs/jobs_kanban_view.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:jobpilot_ai/presentation/widgets/job_filter_bottom_sheet.dart';
import 'package:jobpilot_ai/presentation/widgets/status_chip.dart';
import 'package:shimmer/shimmer.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final _searchController = TextEditingController();
  ApplicationStatus? _statusFilter;
  JobFilterOptions _advancedFilters = const JobFilterOptions();
  String _sortBy = 'appliedDate';
  String _sortOrder = 'desc';
  bool _isKanbanMode = false;
  List<JobApplication>? _lastLoadedJobs;

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(const LoadJobs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applications'),
        actions: [
          IconButton(
            icon: Icon(_isKanbanMode ? Icons.view_list : Icons.view_kanban_outlined),
            tooltip: _isKanbanMode ? 'List View' : 'Kanban Board',
            onPressed: () => setState(() => _isKanbanMode = !_isKanbanMode),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.jobCreateRoute),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobOperationSuccess) {
            context.read<JobBloc>().add(const LoadJobs());
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<JobBloc>();
              await bloc.stream.firstWhere(
                (s) => s is JobsLoaded || s is JobError,
              );
              bloc.add(const LoadJobs());
              await bloc.stream.firstWhere(
                (s) => s is JobsLoaded || s is JobError,
              );
            },
            child: _buildStateContent(state),
          );
        },
      ),
    );
  }

  Widget _buildStateContent(JobState state) {
    switch (state) {
      case JobInitial():
        return const Center(
          child: Text(
            'Initializing jobs data...',
            style: TextStyle(color: Colors.grey),
          )
        );
      case JobLoading():
        return _lastLoadedJobs != null && _lastLoadedJobs!.isNotEmpty
            ? _buildJobsList(context, _lastLoadedJobs!)
            : const _JobsShimmer();
      case JobsLoaded(:final jobs):
        _lastLoadedJobs = jobs;
        return _buildJobsList(context, jobs);
      case JobOperationSuccess():
        return _lastLoadedJobs != null && _lastLoadedJobs!.isNotEmpty
            ? _buildJobsList(context, _lastLoadedJobs!)
            : const _JobsShimmer();
      case JobDetailLoaded():
        return _lastLoadedJobs != null && _lastLoadedJobs!.isNotEmpty
            ? _buildJobsList(context, _lastLoadedJobs!)
            : const _JobsShimmer();
      case AnalyticsLoaded():
        return _lastLoadedJobs != null && _lastLoadedJobs!.isNotEmpty
            ? _buildJobsList(context, _lastLoadedJobs!)
            : const _JobsShimmer();
      case SearchResultsLoaded():
        return _lastLoadedJobs != null && _lastLoadedJobs!.isNotEmpty
            ? _buildJobsList(context, _lastLoadedJobs!)
            : const _JobsShimmer();
      case JobError(:final message):
        return ErrorDisplay(
          message: message,
          onRetry: () => context.read<JobBloc>().add(const LoadJobs()),
        );
    }
  }

  Widget _buildSearchAndFilterBar() {
    final activeFiltersCount = _advancedFilters.activeFilterCount;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search company, role, location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              Badge(
                isLabelVisible: activeFiltersCount > 0,
                label: Text('$activeFiltersCount'),
                child: IconButton.filledTonal(
                  icon: const Icon(Icons.tune),
                  tooltip: 'Filter options',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => JobFilterBottomSheet(
                        initialFilters: _advancedFilters,
                        onApply: (updated) => setState(() => _advancedFilters = updated),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              _buildFilterChip('All', null),
              ...ApplicationStatus.values.map((s) =>
                  _buildFilterChip(_statusLabel(s), s)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Text('Sort by: ', style: TextStyle(fontSize: 13)),
              DropdownButton<String>(
                value: _sortBy,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'appliedDate', child: Text('Date Applied')),
                  DropdownMenuItem(value: 'companyName', child: Text('Company')),
                  DropdownMenuItem(value: 'status', child: Text('Status')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _sortBy = v);
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _sortOrder == 'desc' ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 18,
                ),
                onPressed: () =>
                    setState(() => _sortOrder = _sortOrder == 'desc' ? 'asc' : 'desc'),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, ApplicationStatus? status) {
    final selected = _statusFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _statusFilter = status),
      ),
    );
  }

  List<JobApplication> _filterAndSort(List<JobApplication> jobs) {
    var result = jobs.toList();

    // 1. Status Filter from Chip or Advanced Filter
    if (_statusFilter != null) {
      result = result.where((j) => j.status == _statusFilter).toList();
    } else if (_advancedFilters.statuses.isNotEmpty) {
      result = result.where((j) => _advancedFilters.statuses.contains(j.status)).toList();
    }

    // 2. Search Query (Company, Role, Location, Notes)
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((j) =>
        j.companyName.toLowerCase().contains(query) ||
        j.role.toLowerCase().contains(query) ||
        (j.location != null && j.location!.toLowerCase().contains(query)) ||
        (j.notes != null && j.notes!.toLowerCase().contains(query))
      ).toList();
    }

    // 3. Location Type Filter (Remote, Hybrid, Onsite)
    if (_advancedFilters.locationType != 'all') {
      result = result.where((j) {
        final loc = (j.location ?? '').toLowerCase();
        if (_advancedFilters.locationType == 'remote') return loc.contains('remote');
        if (_advancedFilters.locationType == 'hybrid') return loc.contains('hybrid');
        if (_advancedFilters.locationType == 'onsite') return !loc.contains('remote') && !loc.contains('hybrid') && loc.isNotEmpty;
        return true;
      }).toList();
    }

    // 4. Favorites Only
    if (_advancedFilters.favoritesOnly) {
      result = result.where((j) => j.isFavorite).toList();
    }

    // 5. Notes Only
    if (_advancedFilters.withNotesOnly) {
      result = result.where((j) => j.notes != null && j.notes!.trim().isNotEmpty).toList();
    }

    // 6. Date Range Filter
    if (_advancedFilters.dateRange != 'all') {
      final now = DateTime.now();
      int days = 3650;
      if (_advancedFilters.dateRange == '7d') days = 7;
      if (_advancedFilters.dateRange == '30d') days = 30;
      if (_advancedFilters.dateRange == '90d') days = 90;
      final threshold = now.subtract(Duration(days: days));
      result = result.where((j) => j.appliedDate.isAfter(threshold)).toList();
    }

    // Sort Result
    result.sort((a, b) {
      int cmp;
      switch (_sortBy) {
        case 'companyName':
          cmp = a.companyName.compareTo(b.companyName);
          break;
        case 'status':
          cmp = a.status.name.compareTo(b.status.name);
          break;
        default:
          cmp = a.appliedDate.compareTo(b.appliedDate);
      }
      return _sortOrder == 'desc' ? -cmp : cmp;
    });
    return result;
  }

  Widget _buildJobsList(BuildContext context, List<JobApplication> jobs) {
    final filtered = _filterAndSort(jobs);

    if (_isKanbanMode) {
      return Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(child: JobsKanbanView(jobs: filtered)),
        ],
      );
    }

    if (filtered.isEmpty) {
      final emptyState = _searchController.text.isNotEmpty
          ? const EmptyState(
              icon: Icons.search_off,
              message: 'No jobs match your search',
            )
          : const EmptyState(
              icon: Icons.work_outline,
              message: 'No job applications yet\nTap + to add one',
              actionLabel: 'Add Job',
            );

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchAndFilterBar()),
          SliverFillRemaining(child: emptyState),
        ],
      );
    }

    return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchAndFilterBar()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = filtered[index];
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
              childCount: filtered.length,
            ),
          ),
        ],
      );
  }

  String _statusLabel(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved: return 'Saved';
      case ApplicationStatus.applied: return 'Applied';
      case ApplicationStatus.interview: return 'Interview';
      case ApplicationStatus.offer: return 'Offer';
      case ApplicationStatus.rejected: return 'Rejected';
      case ApplicationStatus.withdrawn: return 'Withdrawn';
    }
  }
}

class _JobsShimmer extends StatelessWidget {
  const _JobsShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(6, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
