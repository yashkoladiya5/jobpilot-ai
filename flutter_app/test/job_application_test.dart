import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/job_application.dart';

void main() {
  group('JobApplication and ApplicationStatus Entity Tests', () {
    test('ApplicationStatus enum values and serialization/deserialization', () {
      expect(ApplicationStatus.saved.value, equals('SAVED'));
      expect(ApplicationStatus.applied.value, equals('APPLIED'));
      expect(ApplicationStatus.interview.value, equals('INTERVIEW'));
      expect(ApplicationStatus.offer.value, equals('OFFER'));
      expect(ApplicationStatus.rejected.value, equals('REJECTED'));
      expect(ApplicationStatus.withdrawn.value, equals('WITHDRAWN'));

      expect(ApplicationStatus.fromJson('INTERVIEW'), equals(ApplicationStatus.interview));
      expect(ApplicationStatus.fromJson('OFFER'), equals(ApplicationStatus.offer));
      // Unknown defaults to saved
      expect(ApplicationStatus.fromJson('UNKNOWN_STATUS'), equals(ApplicationStatus.saved));
    });

    test('JobApplication getters for notes and salaryInfo', () {
      final jobWithInfo = JobApplication(
        id: 'job-1',
        companyName: 'Acme Corp',
        role: 'Tech Lead',
        salaryRange: '\$140k - \$170k',
        location: 'Remote',
        status: ApplicationStatus.applied,
        notes: 'Spoke with hiring manager',
        appliedDate: DateTime.parse('2026-11-20T10:00:00Z'),
        isFavorite: true,
      );

      expect(jobWithInfo.hasNotes, isTrue);
      expect(jobWithInfo.hasSalaryInfo, isTrue);
      expect(jobWithInfo.isFavorite, isTrue);

      final jobWithoutInfo = JobApplication(
        id: 'job-2',
        companyName: 'Beta Labs',
        role: 'Mobile Dev',
        salaryRange: '   ',
        notes: null,
        status: ApplicationStatus.saved,
        appliedDate: DateTime.parse('2026-11-21T10:00:00Z'),
      );

      expect(jobWithoutInfo.hasNotes, isFalse);
      expect(jobWithoutInfo.hasSalaryInfo, isFalse);
      expect(jobWithoutInfo.isFavorite, isFalse);
    });

    test('JobApplication.fromJson deserialization handles standard payloads', () {
      final json = {
        'id': 'job-303',
        'companyName': 'Google DeepMind',
        'role': 'Senior Flutter Engineer',
        'jobUrl': 'https://careers.google.com/jobs/12345',
        'salaryRange': '\$180k - \$220k',
        'location': 'Mountain View, CA',
        'status': 'INTERVIEW',
        'notes': 'Preparing STAR answers for mock session',
        'appliedDate': '2026-11-15T09:00:00.000Z',
        'isFavorite': true,
        'interviewRounds': 3,
      };

      final job = JobApplication.fromJson(json);
      expect(job.id, equals('job-303'));
      expect(job.companyName, equals('Google DeepMind'));
      expect(job.status, equals(ApplicationStatus.interview));
      expect(job.isFavorite, isTrue);
      expect(job.interviewRounds, equals(3));
      expect(job.hasNotes, isTrue);
    });
  });
}
