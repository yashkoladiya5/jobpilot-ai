import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';

void main() {
  group('Resume Entity Tests', () {
    test('fileExtension extracts lowercase extension accurately', () {
      const resume = Resume(
        id: '1',
        userId: 'u1',
        fileName: 'Senior_Dev_CV.PDF',
        filePath: '/uploads/cv.pdf',
      );
      expect(resume.fileExtension, equals('pdf'));
    });

    test('formattedSize formats bytes, KB, and MB correctly', () {
      const unknownSizeResume = Resume(
        id: '1',
        userId: 'u1',
        fileName: 'cv.pdf',
        filePath: '/uploads/cv.pdf',
        fileSize: null,
      );
      expect(unknownSizeResume.formattedSize, equals('Unknown Size'));

      const smallResume = Resume(
        id: '2',
        userId: 'u1',
        fileName: 'cv.txt',
        filePath: '/uploads/cv.txt',
        fileSize: 512,
      );
      expect(smallResume.formattedSize, equals('512 B'));

      const kbResume = Resume(
        id: '3',
        userId: 'u1',
        fileName: 'cv.pdf',
        filePath: '/uploads/cv.pdf',
        fileSize: 1024 * 250, // 250 KB
      );
      expect(kbResume.formattedSize, equals('250.0 KB'));

      const mbResume = Resume(
        id: '4',
        userId: 'u1',
        fileName: 'portfolio.pdf',
        filePath: '/uploads/portfolio.pdf',
        fileSize: 1024 * 1024 * 3, // 3 MB
      );
      expect(mbResume.formattedSize, equals('3.0 MB'));
    });
  });

  group('CoverLetter Entity Tests', () {
    test('CoverLetter.fromJson deserializes correctly with defaults', () {
      final json = {
        'id': 'cl-101',
        'resumeId': 'res-1',
        'resumeFileName': 'My_Resume.docx',
        'jobDescription': 'Looking for a Senior Flutter Architect.',
        'coverLetterText': 'Dear Hiring Manager...',
        'createdAt': '2026-11-20T10:00:00Z',
      };

      final letter = CoverLetter.fromJson(json);
      expect(letter.id, equals('cl-101'));
      expect(letter.resumeFileName, equals('My_Resume.docx'));
      expect(letter.tone, equals('professional'));
      expect(letter.status, equals('COMPLETED'));
      expect(letter.jobId, isNull);
    });

    test('CoverLetter.fromJson extracts nested resume fileName if flat is absent', () {
      final json = {
        'id': 'cl-102',
        'resumeId': 'res-2',
        'resume': {
          'fileName': 'Nested_Resume.pdf',
        },
        'jobDescription': 'Backend Engineer',
        'coverLetterText': 'Hello team...',
        'tone': 'enthusiastic',
        'status': 'PROCESSING',
        'createdAt': '2026-11-20T12:00:00Z',
      };

      final letter = CoverLetter.fromJson(json);
      expect(letter.resumeFileName, equals('Nested_Resume.pdf'));
      expect(letter.tone, equals('enthusiastic'));
      expect(letter.status, equals('PROCESSING'));
    });
  });
}
