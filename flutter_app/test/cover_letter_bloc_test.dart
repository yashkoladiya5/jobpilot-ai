import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/entities/cover_letter.dart';
import 'package:jobpilot_ai/domain/repositories/ai_repository.dart';
import 'package:jobpilot_ai/domain/usecases/ai/generate_cover_letter_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/get_cover_letter_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/get_cover_letters_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_event.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_state.dart';

class FakeAiRepository implements AiRepository {
  Either<Failure, CoverLetter>? generateResult;
  Either<Failure, CoverLetter>? getCoverLetterResult;
  Either<Failure, List<CoverLetter>>? getCoverLettersResult;

  @override
  Future<Either<Failure, CoverLetter>> generateCoverLetter(
    String resumeId,
    String jobDescription, {
    String? jobId,
    String? tone,
  }) async =>
      generateResult ??
      Right(CoverLetter(
        id: 'cl-new',
        resumeId: resumeId,
        resumeFileName: 'resume.pdf',
        jobDescription: jobDescription,
        tone: tone ?? 'professional',
        coverLetterText: 'Generated body text',
        status: 'COMPLETED',
        createdAt: DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, CoverLetter>> getCoverLetter(String id) async =>
      getCoverLetterResult ??
      Right(CoverLetter(
        id: id,
        resumeId: 'res-1',
        resumeFileName: 'resume.pdf',
        jobDescription: 'Senior Dev role',
        tone: 'professional',
        coverLetterText: 'Cover letter body text',
        status: 'COMPLETED',
        createdAt: DateTime(2025, 1, 1),
      ));

  @override
  Future<Either<Failure, List<CoverLetter>>> getCoverLetters() async =>
      getCoverLettersResult ?? const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAiRepository repository;
  late CoverLetterBloc coverLetterBloc;

  final tCoverLetter = CoverLetter(
    id: 'cl-1',
    resumeId: 'res-1',
    resumeFileName: 'alex_cv.pdf',
    jobDescription: 'Senior Engineer role',
    tone: 'professional',
    coverLetterText: 'Dear Hiring Manager, I am writing to apply...',
    status: 'COMPLETED',
    createdAt: DateTime(2025, 2, 1),
  );

  setUp(() {
    repository = FakeAiRepository();
    coverLetterBloc = CoverLetterBloc(
      GenerateCoverLetterUseCase(repository),
      GetCoverLetterUseCase(repository),
      GetCoverLettersUseCase(repository),
    );
  });

  tearDown(() {
    coverLetterBloc.close();
  });

  test('initial state is CoverLetterInitial', () {
    expect(coverLetterBloc.state, isA<CoverLetterInitial>());
  });

  blocTest<CoverLetterBloc, CoverLetterState>(
    'emits [CoverLetterGenerating, CoverLettersLoaded] when LoadCoverLetters succeeds',
    build: () {
      repository.getCoverLettersResult = Right([tCoverLetter]);
      return coverLetterBloc;
    },
    act: (bloc) => bloc.add(const LoadCoverLetters()),
    expect: () => [
      isA<CoverLetterGenerating>(),
      isA<CoverLettersLoaded>().having((s) => s.coverLetters.length, 'length', 1),
    ],
  );

  blocTest<CoverLetterBloc, CoverLetterState>(
    'emits [CoverLetterGenerating, CoverLetterError] when LoadCoverLetters fails',
    build: () {
      repository.getCoverLettersResult =
          const Left(Failure.serverFailure(message: 'Failed to load vault'));
      return coverLetterBloc;
    },
    act: (bloc) => bloc.add(const LoadCoverLetters()),
    expect: () => [
      isA<CoverLetterGenerating>(),
      isA<CoverLetterError>().having((s) => s.message, 'message', 'Failed to load vault'),
    ],
  );

  blocTest<CoverLetterBloc, CoverLetterState>(
    'emits [CoverLetterGenerating, CoverLetterLoaded] when LoadCoverLetter by ID succeeds',
    build: () {
      repository.getCoverLetterResult = Right(tCoverLetter);
      return coverLetterBloc;
    },
    act: (bloc) => bloc.add(const LoadCoverLetter('cl-1')),
    expect: () => [
      isA<CoverLetterGenerating>(),
      isA<CoverLetterLoaded>().having((s) => s.coverLetter.id, 'id', 'cl-1'),
    ],
  );

  blocTest<CoverLetterBloc, CoverLetterState>(
    'emits [CoverLetterGenerating, CoverLetterLoaded] when GenerateCoverLetter succeeds',
    build: () {
      repository.generateResult = Right(tCoverLetter);
      return coverLetterBloc;
    },
    act: (bloc) => bloc.add(const GenerateCoverLetter(
      'res-1',
      'Senior Engineer role',
      tone: 'professional',
    )),
    expect: () => [
      isA<CoverLetterGenerating>(),
      isA<CoverLetterLoaded>().having((s) => s.coverLetter.tone, 'tone', 'professional'),
    ],
  );
}
