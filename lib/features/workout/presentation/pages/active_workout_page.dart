import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/elapsed_time_text.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/widgets/set_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ActiveWorkoutPage extends StatelessWidget {
  const ActiveWorkoutPage({super.key});

  static const _defaultRest = Duration(seconds: 90);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveWorkoutCubit, ActiveWorkoutState>(
      listenWhen: (previous, current) =>
          current.failure != null && current.failure != previous.failure,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
      builder: (context, state) {
        final workout = state.workout;
        if (workout == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Workout')),
            body: Center(
              child: FilledButton(
                onPressed: () =>
                    context.read<ActiveWorkoutCubit>().beginWorkout(),
                child: const Text('Start a workout'),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workout.name),
                ElapsedTimeText(
                  since: workout.startedAt,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Discard',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDiscard(context),
              ),
              TextButton(
                onPressed: state.isBusy
                    ? null
                    : () async {
                        final cubit = context.read<ActiveWorkoutCubit>();
                        await cubit.finish();
                        if (!context.mounted) return;
                        final finished = cubit.state.finishedWorkout;
                        if (finished != null) {
                          cubit.acknowledgeFinished();
                          context.go(AppRoutes.workoutDetail(finished.id));
                        }
                      },
                child: const Text('Finish'),
              ),
            ],
          ),
          body: ContentConstraint(
            maxWidth: 720,
            child: Column(
              children: [
                const _RestTimerBanner(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final entry in workout.exercises)
                        _ExerciseCard(entry: entry),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add exercise'),
                        onPressed: () => _addExercise(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addExercise(BuildContext context) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final exercise = await context.push<Exercise>(
      '${AppRoutes.exerciseLibrary}?pick=1',
    );
    if (exercise != null) await cubit.addExercise(exercise);
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final cubit = context.read<ActiveWorkoutCubit>();
    final router = GoRouter.of(context);
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Discard workout?'),
        content: const Text('Everything logged in this workout will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.discard();
      router.go(AppRoutes.workouts);
    }
  }
}

class _RestTimerBanner extends StatelessWidget {
  const _RestTimerBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestTimerCubit, RestTimerState>(
      builder: (context, state) {
        if (!state.isRunning) return const SizedBox.shrink();
        final cubit = context.read<RestTimerCubit>();
        return Material(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: ListTile(
            title: Text('Rest ${state.remaining.clock}'),
            subtitle: LinearProgressIndicator(value: state.progress),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => cubit.addTime(const Duration(seconds: 15)),
                  child: const Text('+15s'),
                ),
                TextButton(onPressed: cubit.skip, child: const Text('Skip')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.entry});

  final WorkoutExercise entry;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActiveWorkoutCubit>();
    final units = context.unitSystem;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.exercise.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Remove exercise',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => cubit.removeExercise(entry.id),
                ),
              ],
            ),
            for (final set in entry.sets)
              SetRow(
                key: ValueKey(set.id),
                set: set,
                trackingType: entry.exercise.trackingType,
                units: units,
                onChanged: (updated) => cubit.updateSet(entry.id, updated),
                onToggleCompleted: () {
                  cubit.toggleSetCompleted(entry.id, set.id);
                  if (!set.isCompleted) {
                    context.read<RestTimerCubit>().start(
                      ActiveWorkoutPage._defaultRest,
                    );
                  }
                },
                onDelete: () => cubit.removeSet(entry.id, set.id),
              ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add set'),
              onPressed: () => cubit.addSet(entry.id),
            ),
          ],
        ),
      ),
    );
  }
}
