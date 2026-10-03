import 'package:equatable/equatable.dart';

/// One exercise in a planned workout. [target] is reps, or seconds for timed
/// exercises; distance exercises ignore it.
class PlanExercise {
  const PlanExercise(this.exerciseId, this.sets, this.target);

  /// Id of an exercise in the built-in library.
  final String exerciseId;
  final int sets;
  final int target;
}

class PlanDay {
  const PlanDay(this.name, this.exercises);

  final String name;
  final List<PlanExercise> exercises;
}

class TrainingProgram {
  const TrainingProgram({
    required this.id,
    required this.name,
    required this.weeks,
    required this.level,
    required this.blurb,
    required this.days,
  });

  final String id;
  final String name;
  final int weeks;
  final String level;
  final String blurb;

  /// The workouts of one week, in order.
  final List<PlanDay> days;

  int get daysPerWeek => days.length;
  int get totalSessions => weeks * days.length;

  /// Name given to the workout for [dayIndex]; progress is counted from it.
  String workoutName(int dayIndex) =>
      '$name · Day ${dayIndex + 1}: ${days[dayIndex].name}';

  String get workoutPrefix => '$name · Day ';
}

/// A one-off ready-made workout.
class QuickSession {
  const QuickSession({
    required this.id,
    required this.name,
    required this.category,
    required this.minutes,
    required this.level,
    required this.exercises,
  });

  final String id;
  final String name;
  final String category;
  final int minutes;
  final String level;
  final List<PlanExercise> exercises;
}

class ProgramProgress extends Equatable {
  const ProgramProgress({
    required this.program,
    required this.startedAt,
    required this.sessionsDone,
  });

  final TrainingProgram program;
  final DateTime startedAt;
  final int sessionsDone;

  int get total => program.totalSessions;
  bool get isComplete => sessionsDone >= total;
  double get fraction => (sessionsDone / total).clamp(0, 1);
  int get week =>
      (sessionsDone ~/ program.daysPerWeek + 1).clamp(1, program.weeks);
  int get nextDayIndex => sessionsDone % program.daysPerWeek;
  PlanDay get nextDay => program.days[nextDayIndex];

  @override
  List<Object?> get props => [program.id, startedAt, sessionsDone];
}
