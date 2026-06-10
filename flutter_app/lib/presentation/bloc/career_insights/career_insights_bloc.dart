import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_event.dart';
import 'package:jobpilot_ai/presentation/bloc/career_insights/career_insights_state.dart';

@injectable
class CareerInsightsBloc extends Bloc<CareerInsightsEvent, CareerInsightsState> {
  CareerInsightsBloc() : super(CareerInsightsInitial()) {
    on<LoadCareerInsights>(_onLoadCareerInsights);
    on<RefreshCareerInsights>(_onRefreshCareerInsights);
  }

  Future<void> _onLoadCareerInsights(
    LoadCareerInsights event,
    Emitter<CareerInsightsState> emit,
  ) async {
    emit(CareerInsightsLoading());
  }

  Future<void> _onRefreshCareerInsights(
    RefreshCareerInsights event,
    Emitter<CareerInsightsState> emit,
  ) async {
    emit(CareerInsightsLoading());
  }
}
