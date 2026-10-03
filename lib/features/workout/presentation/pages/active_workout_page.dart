import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/elapsed_time_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/widgets/rest_timer_bar.dart';
import 'package:fitness_trakcer/features/workout/presentation/widgets/set_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  bool _focus = true;
  int _exerciseIndex = 0;
  int _setIndex = 0;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocConsumer<ActiveWorkoutCubit, ActiveWorkoutState>(
      listenWhen: (previous, current) =>
          current.failure != null && current.failure != previous.failure,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
      builder: (context, state) {
        final workout = state.workout;
        if (workout == null) {
          return VSubPage(
            title: 'Workout',
            children: [
              VButton(
                'Start a workout',
                height: 54,
                radius: 16,
                expand: true,
                onPressed: () =>
                    context.read<ActiveWorkoutCubit>().beginWorkout(),
              ),
            ],
          );
        }
        final exercises = workout.exercises;
        final total = exercises.fold<int>(0, (n, e) => n + e.sets.length);
        final done = exercises.fold<int>(
          0,
          (n, e) => n + e.sets.where((s) => s.isCompleted).length,
        );
        if (exercises.isNotEmpty) {
          _exerciseIndex = _exerciseIndex.clamp(0, exercises.length - 1);
        }
        return Scaffold(
          body: SafeArea(
            child: ContentConstraint(
              maxWidth: 720,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton.filled(
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              backgroundColor: v.card,
                              foregroundColor: v.ink,
                            ),
                            onPressed: () => context.go(AppRoutes.workouts),
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workout.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: VeyroText.body(
                                  15,
                                  weight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                              Row(
                                children: [
                                  ElapsedTimeText(
                                    since: workout.startedAt,
                                    style: VeyroText.display(19, color: v.mute),
                                  ),
                                  Text(
                                    ' · $done/$total sets',
                                    style: VeyroText.display(19, color: v.mute),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        VSegmented<bool>(
                          options: const {true: 'Focus', false: 'List'},
                          selected: _focus,
                          height: 30,
                          onChanged: (f) => setState(() => _focus = f),
                        ).sized(width: 130),
                        const SizedBox(width: 8),
                        VButton(
                          'Finish',
                          height: 36,
                          onPressed: state.isBusy
                              ? null
                              : () => _confirmFinish(context, done, total),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _focus
                              ? _FocusView(
                                  exercises: exercises,
                                  exerciseIndex: _exerciseIndex,
                                  setIndex: _setIndex,
                                  onExercise: (i) => setState(() {
                                    _exerciseIndex = i;
                                    _setIndex = _firstOpenSet(exercises[i]);
                                  }),
                                  onSet: (i) => setState(() => _setIndex = i),
                                  onAddExercise: () => _addExercise(context),
                                  onDiscard: () => _confirmDiscard(context),
                                )
                              : _ListView(
                                  workout: exercises,
                                  onAddExercise: () => _addExercise(context),
                                  onDiscard: () => _confirmDiscard(context),
                                ),
                        ),
                        const Positioned(
                          left: 12,
                          right: 12,
                          bottom: 8,
                          child: RestTimerBar(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _firstOpenSet(WorkoutExercise e) {
    final i = e.sets.indexWhere((s) => !s.isCompleted);
    return i < 0 ? 0 : i;
  }

  Future<void> _addExercise(BuildContext context) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final exercise = await context.push<Exercise>(
      '${AppRoutes.exerciseLibrary}?pick=1',
    );
    if (exercise == null) return;
    await cubit.addExercise(exercise);
    if (!mounted) return;
    setState(() {
      _exerciseIndex = (cubit.state.workout?.exercises.length ?? 1) - 1;
      _setIndex = 0;
    });
  }

  Future<void> _confirmFinish(BuildContext context, int done, int total) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final router = GoRouter.of(context);
    final ok = await showVeyroConfirm(
      context,
      title: 'Finish workout?',
      message: done < total
          ? '$done of $total sets are done. Unfinished sets will be dropped.'
          : 'All $total sets are done. Nice work.',
      confirmLabel: 'Finish & save',
      cancelLabel: 'Keep going',
    );
    if (!ok) return;
    await cubit.finish();
    final finished = cubit.state.finishedWorkout;
    if (finished != null) {
      cubit.acknowledgeFinished();
      router.go(AppRoutes.workoutDetail(finished.id));
    }
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final router = GoRouter.of(context);
    final ok = await showVeyroConfirm(
      context,
      title: 'Discard workout?',
      message: 'This workout will not be saved.',
      confirmLabel: 'Discard',
      destructive: true,
    );
    if (!ok) return;
    await cubit.discard();
    router.go(AppRoutes.workouts);
  }
}

extension on Widget {
  Widget sized({required double width}) => SizedBox(width: width, child: this);
}

/// One-exercise-at-a-time logging with big steppers.
class _FocusView extends StatelessWidget {
  const _FocusView({
    required this.exercises,
    required this.exerciseIndex,
    required this.setIndex,
    required this.onExercise,
    required this.onSet,
    required this.onAddExercise,
    required this.onDiscard,
  });

  final List<WorkoutExercise> exercises;
  final int exerciseIndex;
  final int setIndex;
  final ValueChanged<int> onExercise;
  final ValueChanged<int> onSet;
  final VoidCallback onAddExercise;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ADD YOUR\nFIRST EXERCISE',
              textAlign: TextAlign.center,
              style: VeyroText.display(40, height: .95),
            ),
            const SizedBox(height: 14),
            VButton(
              '+ Add exercise',
              height: 54,
              radius: 16,
              onPressed: onAddExercise,
            ),
            TextButton(
              onPressed: onDiscard,
              child: Text(
                'Discard workout',
                style: VeyroText.body(
                  14,
                  weight: FontWeight.w600,
                  color: v.mute,
                ),
              ),
            ),
          ],
        ),
      );
    }
    final entry = exercises[exerciseIndex];
    final sets = entry.sets;
    final si = sets.isEmpty ? 0 : setIndex.clamp(0, sets.length - 1);
    final cubit = context.read<ActiveWorkoutCubit>();
    final units = context.unitSystem;
    final allDone = sets.isNotEmpty && sets.every((s) => s.isCompleted);
    final isLast = exerciseIndex == exercises.length - 1;
    final type = entry.exercise.trackingType;
    final steppable = type.tracksWeight || type.tracksReps;

    Widget body;
    if (sets.isEmpty) {
      body = const SizedBox.shrink();
    } else if (!steppable) {
      body = _Hint(
        'Use the list view to log ${entry.exercise.name.toLowerCase()}.',
      );
    } else if (allDone) {
      body = _AllDone(
        volume: entry.volumeKg,
        units: units,
        onAddSet: () => cubit.addSet(entry.id),
        onNext: isLast ? onAddExercise : () => onExercise(exerciseIndex + 1),
        nextLabel: isLast ? '+ Add exercise' : 'Next exercise',
      );
    } else {
      body = _SetEditor(
        entry: entry,
        set: sets[si],
        setIndex: si,
        units: units,
        onChanged: (s) => cubit.updateSet(entry.id, s),
        onComplete: () {
          cubit.toggleSetCompleted(entry.id, sets[si].id);
          WellnessStore.instance.buzz();
          if (WellnessStore.instance.autoRest) {
            context.read<RestTimerCubit>().start(
              WellnessStore.instance.restDuration,
            );
          }
          final next = sets.indexWhere(
            (s) => !s.isCompleted && s.id != sets[si].id,
          );
          if (next >= 0) onSet(next);
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 80),
      child: Column(
        children: [
          Row(
            children: [
              _RoundIcon(
                icon: Icons.chevron_left,
                onPressed: exerciseIndex > 0
                    ? () => onExercise(exerciseIndex - 1)
                    : null,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      entry.exercise.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: VeyroText.display(28),
                    ),
                    Text(
                      '${entry.exercise.muscleGroup.label} · '
                      '${exerciseIndex + 1} of ${exercises.length}',
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
              _RoundIcon(
                icon: isLast ? Icons.add : Icons.chevron_right,
                onPressed: isLast
                    ? onAddExercise
                    : () => onExercise(exerciseIndex + 1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final (i, s) in sets.indexed)
                GestureDetector(
                  onTap: () => onSet(i),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 42),
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: s.isCompleted ? v.acc : v.card,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: i == si ? v.ink : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        s.isWarmup ? 'W' : '${i + 1}',
                        style: VeyroText.display(
                          17,
                          color: s.isCompleted ? VeyroColors.onAccent : v.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () => cubit.addSet(entry.id),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: v.mute, width: 1.5),
                  ),
                  child: Icon(Icons.add, color: v.mute),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: VeyroText.body(14, color: context.veyro.mute),
    ),
  );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 40,
    height: 40,
    child: IconButton.filled(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: context.veyro.card,
        foregroundColor: context.veyro.ink,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    ),
  );
}

class _AllDone extends StatelessWidget {
  const _AllDone({
    required this.volume,
    required this.units,
    required this.onAddSet,
    required this.onNext,
    required this.nextLabel,
  });

  final double volume;
  final UnitSystem units;
  final VoidCallback onAddSet;
  final VoidCallback onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: v.acc, shape: BoxShape.circle),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: VeyroColors.onAccent,
            ),
          ),
          const SizedBox(height: 12),
          Text('ALL SETS DONE', style: VeyroText.display(34)),
          const SizedBox(height: 4),
          Text(
            'Volume ${units.formatWeight(volume, decimals: 0)}',
            style: VeyroText.body(14, color: v.mute),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VButton(
                '+ Add set',
                style: VButtonStyle.card,
                height: 46,
                radius: 14,
                onPressed: onAddSet,
              ),
              const SizedBox(width: 8),
              VButton(
                nextLabel,
                style: VButtonStyle.ink,
                height: 46,
                radius: 14,
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Weight/reps entry for the selected set: steppers and shortcuts; tap a value to type it.
class _SetEditor extends StatefulWidget {
  const _SetEditor({
    required this.entry,
    required this.set,
    required this.setIndex,
    required this.units,
    required this.onChanged,
    required this.onComplete,
  });

  final WorkoutExercise entry;
  final WorkoutSet set;
  final int setIndex;
  final UnitSystem units;
  final ValueChanged<WorkoutSet> onChanged;
  final VoidCallback onComplete;

  @override
  State<_SetEditor> createState() => _SetEditorState();
}

class _SetEditorState extends State<_SetEditor> {
  final Map<String, int> _rpe = {};

  @override
  void didUpdateWidget(_SetEditor old) {
    super.didUpdateWidget(old);
  }

  WorkoutSet get _set => widget.set;
  UnitSystem get _units => widget.units;

  double get _weightDisplay => _set.weightKg == null
      ? 0
      : UnitConverter.weightToDisplay(_set.weightKg!, _units);

  WorkoutSet _withWeight(double display) => _set.copyWith(
    weightKg: UnitConverter.weightFromDisplay(
      display < 0 ? 0 : display,
      _units,
    ),
  );

  Future<void> _edit(bool weight) async {
    final text = await showVeyroInputSheet(
      context,
      title: weight ? 'Weight' : 'Reps',
      label: weight ? 'Weight' : 'Reps',
      unit: weight ? _units.weightUnit : '',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      initial: weight ? _fmt(_weightDisplay) : '${_set.reps ?? 0}',
    );
    final n = tryParseDecimal(text);
    if (n == null) return;
    widget.onChanged(weight ? _withWeight(n) : _set.copyWith(reps: n.round()));
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final entry = widget.entry;
    final type = entry.exercise.trackingType;
    final weightStep = _units == UnitSystem.metric ? 2.5 : 5.0;
    final previous = entry.sets
        .take(widget.setIndex)
        .where((s) => s.isCompleted)
        .lastOrNull;
    final rpe = _rpe[_set.id];

    Widget chip(String label, VoidCallback onTap, {bool on = false}) =>
        Expanded(
          child: SizedBox(
            height: 34,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: on ? v.ink : v.card,
                foregroundColor: on ? v.bg : v.ink,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                textStyle: VeyroText.body(12.5, weight: FontWeight.w600),
              ),
              child: Text(label),
            ),
          ),
        );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (type.tracksWeight) ...[
                      Expanded(
                        child: _StepCard(
                          label: 'Weight ${_units.weightUnit}',
                          value: _fmt(_weightDisplay),
                          selected: false,
                          onTap: () => _edit(true),
                          onMinus: () => widget.onChanged(
                            _withWeight(_weightDisplay - weightStep),
                          ),
                          onPlus: () => widget.onChanged(
                            _withWeight(_weightDisplay + weightStep),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: _StepCard(
                        label: 'Reps',
                        value: '${_set.reps ?? 0}',
                        selected: false,
                        onTap: () => _edit(false),
                        onMinus: () => widget.onChanged(
                          _set.copyWith(
                            reps: ((_set.reps ?? 0) - 1).clamp(0, 999),
                          ),
                        ),
                        onPlus: () => widget.onChanged(
                          _set.copyWith(reps: (_set.reps ?? 0) + 1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (previous != null)
                      VButton(
                        'Last: ${[if (type.tracksWeight && previous.weightKg != null) _units.formatWeight(previous.weightKg!), if (previous.reps != null) '× ${previous.reps}'].join(' ')} ↺',
                        style: VButtonStyle.card,
                        height: 30,
                        onPressed: () => widget.onChanged(
                          _set.copyWith(
                            weightKg: previous.weightKg,
                            reps: previous.reps,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    Text(
                      'Set ${widget.setIndex + 1} of ${entry.sets.length}',
                      style: VeyroText.body(13, color: v.mute),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    chip(
                      rpe == null ? 'RPE' : 'RPE $rpe',
                      () => setState(() {
                        final next = rpe == null ? 6 : rpe + 1;
                        if (next > 10) {
                          _rpe.remove(_set.id);
                        } else {
                          _rpe[_set.id] = next;
                        }
                      }),
                      on: rpe != null,
                    ),
                    const SizedBox(width: 7),
                    chip(
                      'Warm-up',
                      () => widget.onChanged(
                        _set.copyWith(isWarmup: !_set.isWarmup),
                      ),
                      on: _set.isWarmup,
                    ),
                    const SizedBox(width: 7),
                    chip(
                      'Plates',
                      () => context.go('${AppRoutes.tools}?tab=Plates'),
                    ),
                    const SizedBox(width: 7),
                    chip('Note', () => _editNote(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: FilledButton(
            onPressed: widget.onComplete,
            style: FilledButton.styleFrom(
              backgroundColor: v.acc,
              foregroundColor: VeyroColors.onAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              WellnessStore.instance.autoRest
                  ? 'COMPLETE SET · REST ${WellnessStore.instance.restDuration.clock}'
                  : 'COMPLETE SET',
              style: VeyroText.display(
                22,
                color: VeyroColors.onAccent,
              ).copyWith(letterSpacing: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  static String _fmt(double n) =>
      n == n.roundToDouble() ? n.toStringAsFixed(0) : n.toStringAsFixed(1);

  Future<void> _editNote(BuildContext context) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final note = await showVeyroInputSheet(
      context,
      title: 'Workout note',
      label: 'Note',
      initial: cubit.state.workout?.notes ?? '',
    );
    if (note != null) {
      await cubit.setNotes(note.trim().isEmpty ? null : note.trim());
    }
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    Widget step(String t, VoidCallback f) => Expanded(
      child: SizedBox(
        height: 36,
        child: FilledButton(
          onPressed: f,
          style: FilledButton.styleFrom(
            backgroundColor: v.bg,
            foregroundColor: v.ink,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(t, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? v.ink : Colors.transparent,
          width: 2,
        ),
      ),
      child: VCard(
        radius: 20,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VLabel(label),
                  Text(value, style: VeyroText.display(62, height: .95)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                step('−', onMinus),
                const SizedBox(width: 8),
                step('+', onPlus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// All exercises with their sets in editable cards.
class _ListView extends StatelessWidget {
  const _ListView({
    required this.workout,
    required this.onAddExercise,
    required this.onDiscard,
  });

  final List<WorkoutExercise> workout;
  final VoidCallback onAddExercise;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
      children: [
        for (final entry in workout) ...[
          _ExerciseCard(entry: entry),
          const SizedBox(height: 12),
        ],
        VButton(
          '+ Add exercise',
          style: VButtonStyle.ink,
          height: 52,
          radius: 16,
          expand: true,
          onPressed: onAddExercise,
        ),
        const SizedBox(height: 4),
        VTextAction(
          'Discard workout',
          color: VeyroColors.danger,
          onPressed: onDiscard,
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.entry});

  final WorkoutExercise entry;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final cubit = context.read<ActiveWorkoutCubit>();
    final units = context.unitSystem;
    return VCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.exercise.name.toUpperCase(),
                      style: VeyroText.display(24),
                    ),
                    Text(
                      entry.exercise.muscleGroup.label,
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
              VTextAction(
                'Remove',
                onPressed: () => cubit.removeExercise(entry.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final set in entry.sets)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: v.line)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SetRow(
                key: ValueKey(set.id),
                set: set,
                trackingType: entry.exercise.trackingType,
                units: units,
                onChanged: (updated) => cubit.updateSet(entry.id, updated),
                onToggleCompleted: () {
                  cubit.toggleSetCompleted(entry.id, set.id);
                  if (!set.isCompleted) {
                    WellnessStore.instance.buzz();
                    if (WellnessStore.instance.autoRest) {
                      context.read<RestTimerCubit>().start(
                        WellnessStore.instance.restDuration,
                      );
                    }
                  }
                },
                onDelete: () => cubit.removeSet(entry.id, set.id),
              ),
            ),
          VTextAction(
            '+ Add set',
            color: v.ink,
            onPressed: () => cubit.addSet(entry.id),
          ),
        ],
      ),
    );
  }
}
