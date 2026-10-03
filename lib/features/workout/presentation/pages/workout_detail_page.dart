import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: BlocBuilder<WorkoutDetailCubit, WorkoutDetailState>(
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          final workout = state.workout;
          if (workout == null) {
            return ErrorView(
              message: state.failure?.message ?? 'Workout not found.',
            );
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  workout.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '${workout.durationAt(DateTime.now()).clock} · '
                  '${units.formatWeight(workout.totalVolumeKg, decimals: 0)} · '
                  '${workout.caloriesBurned?.round() ?? 0} kcal',
                ),
                const SizedBox(height: 16),
                for (final entry in workout.exercises) ...[
                  Text(
                    entry.exercise.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final set in entry.sets)
                    Text(
                      [
                        '${set.position + 1}.',
                        if (set.weightKg != null)
                          units.formatWeight(set.weightKg!),
                        if (set.reps != null) '× ${set.reps}',
                        if (set.distanceMeters != null)
                          units.formatDistance(set.distanceMeters!),
                        if (set.durationSeconds != null)
                          Duration(seconds: set.durationSeconds!).clock,
                      ].join(' '),
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
