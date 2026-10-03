import 'package:equatable/equatable.dart';

/// Totals for the last seven days (including today) and the seven before.
class WeeklyReport extends Equatable {
  const WeeklyReport({
    required this.start,
    required this.end,
    this.workouts = 0,
    this.prevWorkouts = 0,
    this.activeMinutes = 0,
    this.prevActiveMinutes = 0,
    this.minutesPerDay = const [0, 0, 0, 0, 0, 0, 0],
    this.volumeKg = 0,
    this.prevVolumeKg = 0,
    this.caloriesBurned = 0,
    this.prevCaloriesBurned = 0,
    this.avgSteps = 0,
    this.prevAvgSteps = 0,
    this.distanceKm = 0,
    this.prevDistanceKm = 0,
    this.heaviest,
    this.longestActivityKm = 0,
    this.busiestDay,
    this.busiestMinutes = 0,
    this.insights = const [],
  });

  /// First and last day shown (local dates).
  final DateTime start;
  final DateTime end;

  final int workouts;
  final int prevWorkouts;
  final int activeMinutes;
  final int prevActiveMinutes;

  /// Active minutes for each of the seven days, oldest first.
  final List<int> minutesPerDay;
  final double volumeKg;
  final double prevVolumeKg;
  final int caloriesBurned;
  final int prevCaloriesBurned;
  final int avgSteps;
  final int prevAvgSteps;
  final double distanceKm;
  final double prevDistanceKm;

  /// The heaviest completed set of the week, if any.
  final HeaviestSet? heaviest;

  /// Distance of the longest recorded activity, in km (0 when none).
  final double longestActivityKm;
  final DateTime? busiestDay;
  final int busiestMinutes;

  /// Unit-free sentences, ready to show.
  final List<String> insights;

  bool get isEmpty => workouts == 0 && activeMinutes == 0 && avgSteps == 0;

  @override
  List<Object?> get props => [
    start,
    end,
    workouts,
    prevWorkouts,
    activeMinutes,
    prevActiveMinutes,
    minutesPerDay,
    volumeKg,
    prevVolumeKg,
    caloriesBurned,
    prevCaloriesBurned,
    avgSteps,
    prevAvgSteps,
    distanceKm,
    prevDistanceKm,
    heaviest,
    longestActivityKm,
    busiestDay,
    busiestMinutes,
    insights,
  ];
}

class HeaviestSet extends Equatable {
  const HeaviestSet(this.exerciseName, this.weightKg, this.reps);

  final String exerciseName;
  final double weightKg;
  final int reps;

  @override
  List<Object?> get props => [exerciseName, weightKg, reps];
}
