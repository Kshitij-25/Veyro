import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/calorie_estimator.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_snapshot.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

class SaveTrackedActivityParams {
  const SaveTrackedActivityParams({required this.type, required this.snapshot});

  final TrackedActivityType type;

  /// Final numbers of the finished session.
  final TrackingSnapshot snapshot;
}

/// Stores a finished session, estimating the calories burned.
@lazySingleton
class SaveTrackedActivity
    implements UseCase<TrackedActivity, SaveTrackedActivityParams> {
  const SaveTrackedActivity(
    this._repository,
    this._getLatestWeight,
    this._ids,
    this._clock,
  );

  static const _minimumDuration = Duration(seconds: 10);
  static const _fallbackWeightKg = 70.0;

  final TrackedActivityRepository _repository;
  final GetLatestWeight _getLatestWeight;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<TrackedActivity>> call(SaveTrackedActivityParams params) async {
    final snapshot = params.snapshot;
    if (snapshot.elapsed < _minimumDuration) {
      return const Fail(
        ValidationFailure('This activity was too short to save.'),
      );
    }

    final weightKg =
        (await _getLatestWeight(const NoParams())).dataOrNull ??
        _fallbackWeightKg;
    final hours = snapshot.elapsed.inSeconds / 3600;
    final speedKmh = hours == 0
        ? 0.0
        : (snapshot.distanceMeters / 1000) / hours;

    final activity = TrackedActivity(
      id: _ids.generate(),
      type: params.type,
      startedAt: snapshot.startedAt,
      endedAt: _clock.now(),
      movingDuration: snapshot.elapsed,
      distanceMeters: snapshot.distanceMeters,
      elevationGainMeters: snapshot.elevationGainMeters,
      caloriesKcal: CalorieEstimator.fromMet(
        met: params.type.met(speedKmh),
        weightKg: weightKg,
        duration: snapshot.elapsed,
      ),
      route: snapshot.route,
    );
    final saved = await _repository.saveActivity(activity);
    return saved.map((_) => activity);
  }
}
