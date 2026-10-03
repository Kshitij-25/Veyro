import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine_draft.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/get_routine.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/save_routine.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'routine_editor_cubit.freezed.dart';

@freezed
abstract class RoutineEditorState with _$RoutineEditorState {
  const factory RoutineEditorState({
    @Default(ViewStatus.success) ViewStatus status,
    @Default(RoutineDraft()) RoutineDraft draft,
    @Default(false) bool isSaving,
    @Default(false) bool saved,
    Failure? failure,
  }) = _RoutineEditorState;
}

@injectable
class RoutineEditorCubit extends Cubit<RoutineEditorState> {
  RoutineEditorCubit(this._getRoutine, this._saveRoutine)
    : super(const RoutineEditorState());

  final GetRoutine _getRoutine;
  final SaveRoutine _saveRoutine;

  /// Loads an existing routine for editing; leave [routineId] null to create.
  Future<void> load(String? routineId) async {
    if (routineId == null) return;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getRoutine(routineId);
    result.when(
      success: (routine) => emit(
        state.copyWith(
          status: ViewStatus.success,
          draft: RoutineDraft.fromRoutine(routine),
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }

  void setName(String name) => _update((d) => d.copyWith(name: name));

  void setNotes(String? notes) => _update((d) => d.copyWith(notes: notes));

  void toggleWeekday(int weekday) => _update((d) {
    final days = {...d.scheduledWeekdays};
    if (!days.remove(weekday)) days.add(weekday);
    return d.copyWith(scheduledWeekdays: days);
  });

  void addExercise(Exercise exercise) => _update(
    (d) => d.copyWith(
      exercises: [
        ...d.exercises,
        RoutineExerciseDraft(exercise: exercise),
      ],
    ),
  );

  void removeExercise(int index) =>
      _update((d) => d.copyWith(exercises: [...d.exercises]..removeAt(index)));

  void updateExercise(int index, RoutineExerciseDraft exercise) => _update(
    (d) => d.copyWith(exercises: [...d.exercises]..[index] = exercise),
  );

  Future<void> save() async {
    emit(state.copyWith(isSaving: true, failure: null));
    final result = await _saveRoutine(state.draft);
    emit(
      state.copyWith(
        isSaving: false,
        saved: result.isSuccess,
        failure: result.failureOrNull,
      ),
    );
  }

  void _update(RoutineDraft Function(RoutineDraft draft) change) =>
      emit(state.copyWith(draft: change(state.draft), failure: null));
}
