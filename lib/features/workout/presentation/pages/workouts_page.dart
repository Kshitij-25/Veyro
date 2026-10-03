import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/elapsed_time_text.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Root of the Workouts tab: current workout, shortcuts and history.
class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            tooltip: 'Routines',
            icon: const Icon(Icons.event_repeat),
            onPressed: () => context.go(AppRoutes.routines),
          ),
          IconButton(
            tooltip: 'Exercises',
            icon: const Icon(Icons.fitness_center),
            onPressed: () => context.go(AppRoutes.exerciseLibrary),
          ),
          IconButton(
            tooltip: 'Personal records',
            icon: const Icon(Icons.military_tech_outlined),
            onPressed: () => context.go(AppRoutes.personalRecords),
          ),
        ],
      ),
      body: ContentConstraint(
        maxWidth: 720,
        child: Column(
          children: [
            BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
              builder: (context, state) {
                final workout = state.workout;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(workout?.name ?? 'No workout in progress'),
                    subtitle: workout == null
                        ? null
                        : ElapsedTimeText(since: workout.startedAt),
                    trailing: workout == null
                        ? FilledButton(
                            onPressed: state.isBusy
                                ? null
                                : () async {
                                    final cubit = context
                                        .read<ActiveWorkoutCubit>();
                                    await cubit.beginWorkout();
                                    if (context.mounted) {
                                      context.go(AppRoutes.activeWorkout);
                                    }
                                  },
                            child: const Text('Start'),
                          )
                        : FilledButton(
                            onPressed: () =>
                                context.go(AppRoutes.activeWorkout),
                            child: const Text('Continue'),
                          ),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
                builder: (context, state) {
                  if (state.status.isPending) return const LoadingView();
                  if (state.status.isFailure) {
                    return ErrorView(
                      message:
                          state.failure?.message ?? 'Something went wrong.',
                    );
                  }
                  if (state.workouts.isEmpty) {
                    return const EmptyView(
                      message: 'No completed workouts yet.',
                    );
                  }
                  return ListView.builder(
                    itemCount: state.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = state.workouts[index];
                      return ListTile(
                        title: Text(workout.name),
                        subtitle: Text(
                          '${MaterialLocalizations.of(context).formatMediumDate(workout.startedAt)} · '
                          '${workout.durationAt(DateTime.now()).clock} · '
                          '${units.formatWeight(workout.totalVolumeKg, decimals: 0)} lifted',
                        ),
                        onTap: () =>
                            context.go(AppRoutes.workoutDetail(workout.id)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
