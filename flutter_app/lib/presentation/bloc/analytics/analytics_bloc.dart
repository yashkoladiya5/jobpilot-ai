import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/domain/usecases/analytics/get_pipeline_analytics_usecase.dart';
import 'package:jobpilot_ai/domain/usecases/analytics/get_timeline_data_usecase.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_event.dart';
import 'package:jobpilot_ai/presentation/bloc/analytics/analytics_state.dart';

/// Manages the state of the analytics screen, fetching both pipeline and timeline data.
@injectable
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetPipelineAnalyticsUseCase _getPipeline;
  final GetTimelineDataUseCase _getTimeline;

  AnalyticsBloc(this._getPipeline, this._getTimeline)
      : super(AnalyticsInitial()) {
    on<LoadPipelineAnalytics>(_onLoadPipeline);
    on<LoadTimelineData>(_onLoadTimeline);
    on<RefreshAllAnalytics>(_onRefreshAll);
  }

  Future<void> _onLoadPipeline(
    LoadPipelineAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    final isAlreadyLoaded = state is AnalyticsLoaded;
    if (!isAlreadyLoaded) emit(AnalyticsLoading());
    
    final result = await _getPipeline();
    result.fold(
      (failure) {
        if (!isAlreadyLoaded) emit(AnalyticsError(failure.message));
      },
      (analytics) {
        if (state is AnalyticsLoaded) {
          emit((state as AnalyticsLoaded).copyWith(analytics: analytics));
        } else {
          emit(AnalyticsLoaded(analytics: analytics));
        }
      },
    );
  }

  Future<void> _onLoadTimeline(
    LoadTimelineData event,
    Emitter<AnalyticsState> emit,
  ) async {
    final currentState = state;
    if (currentState is AnalyticsLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }

    final timelineResult = await _getTimeline();
    timelineResult.fold(
      (failure) {
        if (currentState is! AnalyticsLoaded) {
          emit(AnalyticsError(failure.message));
        } else {
          emit(currentState.copyWith(isRefreshing: false));
        }
      },
      (timeline) {
        if (currentState is AnalyticsLoaded) {
          emit(currentState.copyWith(timeline: timeline, isRefreshing: false));
        }
      },
    );
  }

  Future<void> _onRefreshAll(
    RefreshAllAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    final pipelineResult = await _getPipeline();
    final timelineResult = await _getTimeline();
    pipelineResult.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (analytics) {
        timelineResult.fold(
          (failure) => emit(AnalyticsLoaded(analytics: analytics)),
          (timeline) => emit(
              AnalyticsLoaded(analytics: analytics, timeline: timeline)),
        );
      },
    );
  }
}
