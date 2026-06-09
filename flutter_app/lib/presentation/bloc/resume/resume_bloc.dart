import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/errors/failures.dart';
import 'package:jobpilot_ai/domain/usecases/resume/upload_resume_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/get_resumes_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/resume/delete_resume_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/resume/resume_state.dart';

@injectable
class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final GetResumesUseCase _getResumesUseCase;
  final UploadResumeUseCase _uploadResumeUseCase;
  final DeleteResumeUseCase _deleteResumeUseCase;

  ResumeBloc(
    this._getResumesUseCase,
    this._uploadResumeUseCase,
    this._deleteResumeUseCase,
  ) : super(const ResumeInitial()) {
    on<LoadResumes>(_onLoadResumes);
    on<UploadResume>(_onUploadResume);
    on<DeleteResume>(_onDeleteResume);
    on<SetPrimaryResume>(_onSetPrimaryResume);
  }

  Future<void> _onLoadResumes(
    LoadResumes event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await _getResumesUseCase();
    await result.fold(
      (failure) async => emit(ResumeError(_mapFailureToMessage(failure))),
      (resumes) async => emit(ResumesLoaded(resumes)),
    );
  }

  Future<void> _onUploadResume(
    UploadResume event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await _uploadResumeUseCase(event.filePath);
    await result.fold(
      (failure) async => emit(ResumeError(_mapFailureToMessage(failure))),
      (resume) async {
        emit(UploadSuccess(resume));
        _reload(emit);
      },
    );
  }

  Future<void> _onDeleteResume(
    DeleteResume event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeLoading());
    final result = await _deleteResumeUseCase(event.id);
    await result.fold(
      (failure) async => emit(ResumeError(_mapFailureToMessage(failure))),
      (_) async {
        emit(const ResumeOperationSuccess('Resume deleted successfully'));
        _reload(emit);
      },
    );
  }

  Future<void> _onSetPrimaryResume(
    SetPrimaryResume event,
    Emitter<ResumeState> emit,
  ) async {
    emit(const ResumeOperationSuccess('Coming soon'));
  }

  Future<void> _reload(Emitter<ResumeState> emit) async {
    final result = await _getResumesUseCase();
    await result.fold(
      (failure) async => emit(ResumeError(_mapFailureToMessage(failure))),
      (resumes) async => emit(ResumesLoaded(resumes)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      serverFailure: (message, code) => message,
      networkFailure: (message, code) => message,
      authFailure: (message, code) => message,
      validationFailure: (message, code) => message,
      cacheFailure: (message, code) => message,
      notFoundFailure: (message, code) => message,
    );
  }
}
