import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';

/// One training session, whether logged in the app or imported from Health.
class TrainingSession {
  const TrainingSession(this.startedAt, this.endedAt);

  final DateTime startedAt;
  final DateTime endedAt;
}

/// Merges in-app workouts with recorded and Health-imported activities so a
/// session counts once. A Watch workout that overlaps an in-app workout is the
/// same session recorded twice and is dropped.
abstract final class TrainingSessions {
  static List<TrainingSession> merge(
    List<Workout> workouts,
    List<TrackedActivity> activities, {
    required DateTime now,
  }) {
    final own = [
      for (final w in workouts) TrainingSession(w.startedAt, w.endedAt ?? now),
    ];
    final imported = [
      for (final a in activities)
        if (!own.any((w) => _overlaps(w, a.startedAt, a.endedAt)))
          TrainingSession(a.startedAt, a.endedAt),
    ];
    return [...own, ...imported];
  }

  /// Tracked activities that are not duplicates of an in-app workout.
  static List<TrackedActivity> withoutDuplicates(
    List<Workout> workouts,
    List<TrackedActivity> activities, {
    required DateTime now,
  }) => [
    for (final a in activities)
      if (!workouts.any(
        (w) => _overlaps(
          TrainingSession(w.startedAt, w.endedAt ?? now),
          a.startedAt,
          a.endedAt,
        ),
      ))
        a,
  ];

  /// True when the intervals share more than half of the shorter one.
  static bool _overlaps(TrainingSession s, DateTime start, DateTime end) {
    final from = s.startedAt.isAfter(start) ? s.startedAt : start;
    final to = s.endedAt.isBefore(end) ? s.endedAt : end;
    final shared = to.difference(from).inSeconds;
    if (shared <= 0) return false;
    final shorter = [
      s.endedAt.difference(s.startedAt).inSeconds,
      end.difference(start).inSeconds,
    ].reduce((a, b) => a < b ? a : b);
    return shorter <= 0 || shared / shorter > 0.5;
  }
}
