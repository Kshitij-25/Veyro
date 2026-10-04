import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/training_sessions.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/heart_rate_zones.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/muscle_recovery.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_details.dart';
import 'package:fitness_trakcer/features/recovery/domain/repositories/recovery_repository.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRecoveryDetails implements UseCase<RecoveryDetails, NoParams> {
  const GetRecoveryDetails(
    this._workouts,
    this._tracked,
    this._recovery,
    this._profile,
    this._clock,
  );

  static const zoneDays = 7;

  final WorkoutRepository _workouts;
  final TrackedActivityRepository _tracked;
  final RecoveryRepository _recovery;
  final ProfileRepository _profile;
  final Clock _clock;

  @override
  Future<Result<RecoveryDetails>> call(NoParams params) => guard(() async {
    final now = _clock.now();
    final workouts = (await _workouts.getCompletedWorkouts(
      DateRange.lastDays(14, until: now),
    )).getOrThrow();
    final tracked =
        (await _tracked.getActivities(DateRange.lastDays(14, until: now)))
            .dataOrNull ??
        const [];
    final muscles = MuscleRecoveryCalculator.compute(
      workouts,
      now,
      imported: TrainingSessions.withoutDuplicates(workouts, tracked, now: now),
    );

    // Zones need Health heart rate and an age for the max-HR estimate. Either
    // can be missing, so a failure here only hides the zones card.
    HeartRateZones? zones;
    final profile = (await _profile.getProfile()).dataOrNull;
    final samples = (await _recovery.getHeartRateSamples(
      now: now,
      days: zoneDays,
    )).dataOrNull;
    if (profile != null && samples != null && samples.isNotEmpty) {
      final maxHr = 220 - profile.ageOn(now);
      zones = HeartRateZoneCalculator.compute(samples, maxHr);
    }
    return RecoveryDetails(muscles: muscles, zones: zones);
  });
}
