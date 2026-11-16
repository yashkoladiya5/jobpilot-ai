import 'package:flutter/material.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';

class JobFilterOptions {
  final Set<ApplicationStatus> statuses;
  final String locationType; // 'all', 'remote', 'hybrid', 'onsite'
  final bool favoritesOnly;
  final bool withNotesOnly;
  final double minSalary;
  final String dateRange; // 'all', '7d', '30d', '90d'

  const JobFilterOptions({
    this.statuses = const {},
    this.locationType = 'all',
    this.favoritesOnly = false,
    this.withNotesOnly = false,
    this.minSalary = 0,
    this.dateRange = 'all',
  });

  bool get hasActiveFilters =>
      statuses.isNotEmpty ||
      locationType != 'all' ||
      favoritesOnly ||
      withNotesOnly ||
      minSalary > 0 ||
      dateRange != 'all';

  int get activeFilterCount {
    int count = 0;
    if (statuses.isNotEmpty) count += statuses.length;
    if (locationType != 'all') count++;
    if (favoritesOnly) count++;
    if (withNotesOnly) count++;
    if (minSalary > 0) count++;
    if (dateRange != 'all') count++;
    return count;
  }

  JobFilterOptions copyWith({
    Set<ApplicationStatus>? statuses,
    String? locationType,
    bool? favoritesOnly,
    bool? withNotesOnly,
    double? minSalary,
    String? dateRange,
  }) {
    return JobFilterOptions(
      statuses: statuses ?? this.statuses,
      locationType: locationType ?? this.locationType,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      withNotesOnly: withNotesOnly ?? this.withNotesOnly,
      minSalary: minSalary ?? this.minSalary,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

class JobFilterBottomSheet extends StatefulWidget {
  final JobFilterOptions initialFilters;
  final Function(JobFilterOptions) onApply;

  const JobFilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  late Set<ApplicationStatus> _statuses;
  late String _locationType;
  late bool _favoritesOnly;
  late bool _withNotesOnly;
  late double _minSalary;
  late String _dateRange;

  @override
  void initState() {
    super.initState();
    _statuses = Set.from(widget.initialFilters.statuses);
    _locationType = widget.initialFilters.locationType;
    _favoritesOnly = widget.initialFilters.favoritesOnly;
    _withNotesOnly = widget.initialFilters.withNotesOnly;
    _minSalary = widget.initialFilters.minSalary;
    _dateRange = widget.initialFilters.dateRange;
  }

  void _reset() {
    setState(() {
      _statuses.clear();
      _locationType = 'all';
      _favoritesOnly = false;
      _withNotesOnly = false;
      _minSalary = 0;
      _dateRange = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Applications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset All'),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildSectionHeader('Application Status'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ApplicationStatus.values.map((status) {
                final isSelected = _statuses.contains(status);
                return FilterChip(
                  label: Text(_formatStatus(status)),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _statuses.add(status);
                      } else {
                        _statuses.remove(status);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Workplace Type'),
            Row(
              children: [
                _buildChoiceChip('All', 'all', _locationType, (val) => setState(() => _locationType = val)),
                const SizedBox(width: 8),
                _buildChoiceChip('Remote', 'remote', _locationType, (val) => setState(() => _locationType = val)),
                const SizedBox(width: 8),
                _buildChoiceChip('Hybrid', 'hybrid', _locationType, (val) => setState(() => _locationType = val)),
                const SizedBox(width: 8),
                _buildChoiceChip('Onsite', 'onsite', _locationType, (val) => setState(() => _locationType = val)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Applied Date Range'),
            Wrap(
              spacing: 8,
              children: [
                _buildChoiceChip('All Time', 'all', _dateRange, (val) => setState(() => _dateRange = val)),
                _buildChoiceChip('Last 7 Days', '7d', _dateRange, (val) => setState(() => _dateRange = val)),
                _buildChoiceChip('Last 30 Days', '30d', _dateRange, (val) => setState(() => _dateRange = val)),
                _buildChoiceChip('Last 90 Days', '90d', _dateRange, (val) => setState(() => _dateRange = val)),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Minimum Target Salary'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _minSalary > 0 ? '\$${_minSalary.toInt()}k+/yr' : 'Any salary',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Slider(
              value: _minSalary,
              max: 250,
              divisions: 25,
              label: _minSalary > 0 ? '\$${_minSalary.toInt()}k' : 'Any',
              onChanged: (val) => setState(() => _minSalary = val),
            ),
            const SizedBox(height: 12),
            _buildSectionHeader('Preferences'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Starred / Favorites only'),
              value: _favoritesOnly,
              onChanged: (v) => setState(() => _favoritesOnly = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Has personal notes'),
              value: _withNotesOnly,
              onChanged: (v) => setState(() => _withNotesOnly = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final filters = JobFilterOptions(
                    statuses: _statuses,
                    locationType: _locationType,
                    favoritesOnly: _favoritesOnly,
                    withNotesOnly: _withNotesOnly,
                    minSalary: _minSalary,
                    dateRange: _dateRange,
                  );
                  widget.onApply(filters);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildChoiceChip(
    String label,
    String value,
    String groupValue,
    Function(String) onSelected,
  ) {
    final isSelected = groupValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
      onSelected: (_) => onSelected(value),
    );
  }

  String _formatStatus(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return 'Saved';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
