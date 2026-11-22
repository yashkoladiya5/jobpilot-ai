import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';
import 'package:jobpilot_ai/presentation/widgets/job_filter_bottom_sheet.dart';

void main() {
  group('JobFilterOptions Unit Tests', () {
    test('default options have no active filters and zero active count', () {
      const options = JobFilterOptions();
      expect(options.hasActiveFilters, isFalse);
      expect(options.activeFilterCount, equals(0));
      expect(options.statuses, isEmpty);
      expect(options.locationType, equals('all'));
      expect(options.favoritesOnly, isFalse);
      expect(options.withNotesOnly, isFalse);
      expect(options.minSalary, equals(0));
      expect(options.dateRange, equals('all'));
    });

    test('activeFilterCount correctly reflects status and toggle filters', () {
      final options = const JobFilterOptions().copyWith(
        statuses: {ApplicationStatus.applied, ApplicationStatus.interview},
        locationType: 'remote',
        favoritesOnly: true,
        withNotesOnly: true,
        minSalary: 80000,
        dateRange: '30d',
      );

      expect(options.hasActiveFilters, isTrue);
      // 2 statuses + 1 location + 1 fav + 1 notes + 1 minSalary + 1 dateRange = 7
      expect(options.activeFilterCount, equals(7));
    });

    test('copyWith preserves existing attributes when unspecified', () {
      final initial = const JobFilterOptions().copyWith(
        locationType: 'hybrid',
        minSalary: 50000,
      );

      final modified = initial.copyWith(favoritesOnly: true);

      expect(modified.locationType, equals('hybrid'));
      expect(modified.minSalary, equals(50000));
      expect(modified.favoritesOnly, isTrue);
      expect(modified.activeFilterCount, equals(3));
    });
  });
}
