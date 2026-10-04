import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_period.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/achievement_repository.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/get_goal_progress.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/training_sessions.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Checks every locked achievement against the user's data and unlocks the
/// ones that were earned. Returns the achievements unlocked by this call.
@lazySingleton
class EvaluateAchievements implements UseCase<List<Achievement>, NoParams> {
  const EvaluateAchievements(
    this._achievements,
    this._workouts,
    this._trackedActivities,
    this._activity,
    this._getGoalProgress,
    this._clock,
  );

  final AchievementRepository _achievements;
  final WorkoutRepository _workouts;
  final TrackedActivityRepository _trackedActivities;
  final ActivityRepository _activity;
  final GetGoalProgress _getGoalProgress;
  final Clock _clock;

  @override
  Future<Result<List<Achievement>>> call(NoParams params) async {
    final unlockedResult = await _achievements.getUnlocked();
    if (unlockedResult case Fail(:final failure)) return Fail(failure);
    final alreadyUnlocked = {
      for (final a in unlockedResult.dataOrNull!) a.type,
    };
    final locked = [
      for (final type in AchievementType.values)
        if (!alreadyUnlocked.contains(type)) type,
    ];
    if (locked.isEmpty) return const Success([]);

    return guard(() async {
      final now = _clock.now();
      final everything = DateRange(DateTime(1970), DateTime(2100));
      final tracked =
          (await _trackedActivities.getActivities(everything)).dataOrNull ??
          const [];
      final ownWorkouts =
          (await _workouts.getCompletedWorkouts(everything)).dataOrNull ??
          const [];
      final workoutCount = TrainingSessions.merge(
        ownWorkouts,
        tracked,
        now: now,
      ).length;
      final totalDistance = tracked.fold<double>(
        0,
        (sum, a) => sum + a.distanceMeters,
      );
      final recentDays =
          (await _activity.getRange(
            DateRange.lastDays(365, until: now.startOfDay),
          )).dataOrNull ??
          const [];
      final bestSteps = recentDays.fold<int>(
        0,
        (best, d) => d.steps > best ? d.steps : best,
      );
      final progress =
          (await _getGoalProgress(const NoParams())).dataOrNull ?? const [];
      final hasDailyStreak = progress.any(
        (p) => p.goal.type.period == GoalPeriod.daily && p.longestStreak >= 7,
      );
      final reachedWeight = progress.any(
        (p) => p.goal.type == GoalType.targetWeight && p.isAchieved,
      );

      bool earned(AchievementType type) => switch (type) {
        AchievementType.firstWorkout => workoutCount >= 1,
        AchievementType.tenWorkouts => workoutCount >= 10,
        AchievementType.fiftyWorkouts => workoutCount >= 50,
        AchievementType.firstTrackedActivity => tracked.isNotEmpty,
        AchievementType.distance100Km => totalDistance >= 100000,
        AchievementType.tenThousandSteps => bestSteps >= 10000,
        AchievementType.sevenDayStreak => hasDailyStreak,
        AchievementType.weightGoalReached => reachedWeight,
      };

      final newlyUnlocked = <Achievement>[];
      for (final type in locked.where(earned)) {
        await _achievements.unlock(type, now);
        newlyUnlocked.add(Achievement(type: type, unlockedAt: now));
      }
      return newlyUnlocked;
    });
  }
}
