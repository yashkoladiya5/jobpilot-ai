import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/domain/usecases/ai/generate_cover_letter_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/get_cover_letter_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/ai/get_cover_letters_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_event.dart';
import 'package:jobpilot_ai/presentation/bloc/cover_letter/cover_letter_state.dart';

/// Manages the state for cover letter generation and viewing operations.
@injectable
class CoverLetterBloc extends Bloc<CoverLetterEvent, CoverLetterState> {
  final GenerateCoverLetterUseCase _generateUseCase;
  final GetCoverLetterUseCase _getUseCase;
  final GetCoverLettersUseCase _getListUseCase;

  CoverLetterBloc(
    this._generateUseCase,
    this._getUseCase,
    this._getListUseCase,
  ) : super(CoverLetterInitial()) {
    on<GenerateCoverLetter>(_onGenerate);
    on<LoadCoverLetters>(_onLoadList);
    on<LoadCoverLetter>(_onLoad);
  }

  Future<void> _onGenerate(
    GenerateCoverLetter event,
    Emitter<CoverLetterState> emit,
  ) async {
    emit(CoverLetterGenerating());
    final result = await _generateUseCase(
      event.resumeId,
      event.jobDescription,
      jobId: event.jobId,
      tone: event.tone,
    );
    result.fold(
      (failure) => emit(CoverLetterError(failure.message)),
      (coverLetter) => emit(CoverLetterLoaded(coverLetter)),
    );
  }

  Future<void> _onLoadList(
    LoadCoverLetters event,
    Emitter<CoverLetterState> emit,
  ) async {
    emit(CoverLetterGenerating());
    final result = await _getListUseCase();
    result.fold(
      (failure) => emit(CoverLetterError(failure.message)),
      (coverLetters) => emit(CoverLettersLoaded(coverLetters)),
    );
  }

  Future<void> _onLoad(
    LoadCoverLetter event,
    Emitter<CoverLetterState> emit,
  ) async {
    emit(CoverLetterGenerating());
    final result = await _getUseCase(event.id);
    result.fold(
      (failure) => emit(CoverLetterError(failure.message)),
      (coverLetter) => emit(CoverLetterLoaded(coverLetter)),
    );
  }
}
