import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:fitness_trakcer/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/evaluate_achievements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_cubit.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(ViewStatus.initial) ViewStatus status,
    DashboardSummary? summary,

    /// Achievements unlocked by the latest refresh.
    @Default([]) List<Achievement> newlyUnlocked,
    Failure? failure,
  }) = _DashboardState;
}

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardSummary, this._evaluateAchievements)
    : super(const DashboardState());

  final GetDashboardSummary _getDashboardSummary;
  final EvaluateAchievements _evaluateAchievements;

  /// Loads (or reloads) today's summary and checks for new achievements.
  Future<void> load() async {
    if (state.summary == null) emit(state.copyWith(status: ViewStatus.loading));
    final unlocked = await _evaluateAchievements(const NoParams());
    final result = await _getDashboardSummary(const NoParams());
    if (isClosed) return;
    result.when(
      success: (summary) => emit(
        state.copyWith(
          status: ViewStatus.success,
          summary: summary,
          newlyUnlocked: unlocked.dataOrNull ?? const [],
          failure: null,
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }
}
