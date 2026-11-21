import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';
import 'package:jobpilot_ai/domain/usecases/resume/delete_resume_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/get_resumes_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/set_primary_resume_usecase.dart';

class MockResumeRepository implements ResumeRepository {
  final List<Resume> _resumes = [
    const Resume(
      id: 'res-1',
      userId: 'u1',
      fileName: 'Resume_Engineering.pdf',
      filePath: '/path/res1.pdf',
      isPrimary: true,
    ),
  ];

  @override
  Future<Either<Failure, List<Resume>>> getResumes() async {
    return Right(_resumes);
  }

  @override
  Future<Either<Failure, Resume>> setPrimaryResume(String id) async {
    final index = _resumes.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = _resumes[index].copyWith(isPrimary: true);
      return Right(updated);
    }
    return const Left(Failure.notFoundFailure(message: 'Resume not found'));
  }

  @override
  Future<Either<Failure, void>> deleteResume(String id) async {
    _resumes.removeWhere((r) => r.id == id);
    return const Right(null);
  }

  @override
  Future<Either<Failure, Resume>> uploadResume(dynamic file) async {
    const newResume = Resume(
      id: 'res-new',
      userId: 'u1',
      fileName: 'Uploaded.pdf',
      filePath: '/path/uploaded.pdf',
    );
    _resumes.add(newResume);
    return const Right(newResume);
  }
}

void main() {
  late MockResumeRepository mockRepo;
  late GetResumesUseCase getResumesUseCase;
  late SetPrimaryResumeUseCase setPrimaryUseCase;
  late DeleteResumeUseCase deleteUseCase;

  setUp(() {
    mockRepo = MockResumeRepository();
    getResumesUseCase = GetResumesUseCase(mockRepo);
    setPrimaryUseCase = SetPrimaryResumeUseCase(mockRepo);
    deleteUseCase = DeleteResumeUseCase(mockRepo);
  });

  group('Resume UseCases Unit Tests', () {
    test('GetResumesUseCase retrieves list of resumes', () async {
      final result = await getResumesUseCase();
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (list) => expect(list.length, equals(1)),
      );
    });

    test('SetPrimaryResumeUseCase updates and returns primary resume', () async {
      final result = await setPrimaryUseCase('res-1');
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (res) => expect(res.isPrimary, isTrue),
      );
    });

    test('SetPrimaryResumeUseCase returns NotFoundFailure for missing ID', () async {
      final result = await setPrimaryUseCase('non-existent');
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('DeleteResumeUseCase completes successfully', () async {
      final result = await deleteUseCase('res-1');
      expect(result.isRight(), isTrue);
    });
  });
}
