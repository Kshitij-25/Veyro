import 'package:fitness_trakcer/features/routines/domain/entities/routine_exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine.freezed.dart';

@freezed
abstract class Routine with _$Routine {
  const factory Routine({
    required String id,
    required String name,
    required DateTime createdAt,
    String? notes,
    @Default([]) List<RoutineExercise> exercises,

    /// ISO weekdays (1 = Monday … 7 = Sunday) this routine is planned for.
    @Default({}) Set<int> scheduledWeekdays,
  }) = _Routine;

  const Routine._();

  bool isScheduledOn(DateTime date) => scheduledWeekdays.contains(date.weekday);
}
