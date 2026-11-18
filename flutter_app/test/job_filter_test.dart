import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/widgets/job_filter_bottom_sheet.dart';

void main() {
  group('JobFilterOptions unit tests', () {
    test('default options should have no active filters', () {
      const options = JobFilterOptions();
      expect(options.hasActiveFilters, isFalse);
      expect(options.activeFilterCount, equals(0));
    });

    test('activeFilterCount reflects selected statuses', () {
      final options = const JobFilterOptions().copyWith(
        statuses: {ApplicationStatus.interview, ApplicationStatus.offer},
      );
      expect(options.hasActiveFilters, isTrue);
      expect(options.activeFilterCount, equals(2));
    });

    test('activeFilterCount reflects location type and min salary', () {
      final options = const JobFilterOptions().copyWith(
        locationType: 'remote',
        minSalary: 100,
        favoritesOnly: true,
      );
      expect(options.hasActiveFilters, isTrue);
      expect(options.activeFilterCount, equals(3));
    });

    test('dateRange filter activates correctly', () {
      final options = const JobFilterOptions().copyWith(dateRange: '30d');
      expect(options.hasActiveFilters, isTrue);
      expect(options.activeFilterCount, equals(1));
    });
  });
}
