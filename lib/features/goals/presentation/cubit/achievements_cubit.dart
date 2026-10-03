import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/evaluate_achievements.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/get_achievements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'achievements_cubit.freezed.dart';

@freezed
abstract class AchievementsState with _$AchievementsState {
  const factory AchievementsState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<Achievement> achievements,

    /// Unlocked by the latest evaluation, so the UI can celebrate them.
    @Default([]) List<Achievement> newlyUnlocked,
    Failure? failure,
  }) = _AchievementsState;
}

@injectable
class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit(this._evaluateAchievements, this._getAchievements)
    : super(const AchievementsState());

  final EvaluateAchievements _evaluateAchievements;
  final GetAchievements _getAchievements;

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));
    final evaluated = await _evaluateAchievements(const NoParams());
    final all = await _getAchievements(const NoParams());
    all.when(
      success: (achievements) => emit(
        state.copyWith(
          status: ViewStatus.success,
          achievements: achievements,
          newlyUnlocked: evaluated.dataOrNull ?? const [],
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }
}
