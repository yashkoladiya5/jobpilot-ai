import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/resume.dart';
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart';
import 'package:jobpilot_ai/domain/usecases/resume/delete_resume_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/get_resumes_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/set_primary_resume_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/upload_resume_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_state.dart';

class FakeResumeRepository implements ResumeRepository {
  Either<Failure, List<Resume>>? getResumesResult;
  Either<Failure, Resume>? uploadResumeResult;
  Either<Failure, Unit>? deleteResumeResult;
  Either<Failure, Resume>? setPrimaryResumeResult;

  @override
  Future<Either<Failure, List<Resume>>> getResumes() async =>
      getResumesResult ?? const Right([]);

  @override
  Future<Either<Failure, Resume>> uploadResume(String filePath) async =>
      uploadResumeResult ??
      Right(Resume(
        id: 'res-new',
        userId: 'u1',
        fileName: 'resume.pdf',
        filePath: 'http://example.com/resume.pdf',
        isPrimary: false,
        createdAt: DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, Unit>> deleteResume(String id) async =>
      deleteResumeResult ?? const Right(unit);

  @override
  Future<Either<Failure, Resume>> setPrimaryResume(String id) async =>
      setPrimaryResumeResult ??
      Right(Resume(
        id: id,
        userId: 'u1',
        fileName: 'resume.pdf',
        filePath: 'http://example.com/resume.pdf',
        isPrimary: true,
        createdAt: DateTime(2025, 1, 1),
      ));
}

void main() {
  late FakeResumeRepository repository;
  late ResumeBloc resumeBloc;

  final tResume = Resume(
    id: 'res-1',
    userId: 'user-1',
    fileName: 'alex_cv.pdf',
    filePath: 'https://storage.jobpilot.ai/alex_cv.pdf',
    isPrimary: true,
    createdAt: DateTime(2025, 2, 1),
  );

  setUp(() {
    repository = FakeResumeRepository();
    resumeBloc = ResumeBloc(
      GetResumesUseCase(repository),
      UploadResumeUseCase(repository),
      DeleteResumeUseCase(repository),
      SetPrimaryResumeUseCase(repository),
    );
  });

  tearDown(() {
    resumeBloc.close();
  });

  test('initial state is ResumeInitial', () {
    expect(resumeBloc.state, equals(const ResumeInitial()));
  });

  blocTest<ResumeBloc, ResumeState>(
    'emits [ResumeLoading, ResumesLoaded] when LoadResumes succeeds',
    build: () {
      repository.getResumesResult = Right([tResume]);
      return resumeBloc;
    },
    act: (bloc) => bloc.add(const LoadResumes()),
    expect: () => [
      const ResumeLoading(),
      ResumesLoaded([tResume]),
    ],
  );

  blocTest<ResumeBloc, ResumeState>(
    'emits [ResumeLoading, ResumeError] when LoadResumes fails',
    build: () {
      repository.getResumesResult = const Left(Failure.serverFailure(message: 'Network issue'));
      return resumeBloc;
    },
    act: (bloc) => bloc.add(const LoadResumes()),
    expect: () => [
      const ResumeLoading(),
      const ResumeError('Network issue'),
    ],
  );

  blocTest<ResumeBloc, ResumeState>(
    'emits [ResumeError] when UploadResume has invalid extension',
    build: () => resumeBloc,
    act: (bloc) => bloc.add(const UploadResume('/path/to/file.exe')),
    expect: () => [
      const ResumeError('Invalid file format. Only PDF, DOC, and DOCX are allowed.'),
    ],
  );

  blocTest<ResumeBloc, ResumeState>(
    'emits [ResumeLoading, ResumeOperationSuccess, ResumesLoaded] when DeleteResume succeeds',
    build: () {
      repository.deleteResumeResult = const Right(unit);
      repository.getResumesResult = const Right([]);
      return resumeBloc;
    },
    act: (bloc) => bloc.add(const DeleteResume('res-1')),
    expect: () => [
      const ResumeLoading(),
      const ResumeOperationSuccess('Resume deleted successfully'),
      const ResumesLoaded([]),
    ],
  );
}
