import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/routines/presentation/cubit/routine_editor_cubit.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoutineEditorPage extends StatelessWidget {
  const RoutineEditorPage({super.key});

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoutineEditorCubit, RoutineEditorState>(
      listener: (context, state) {
        if (state.saved) {
          context.pop();
        } else if (state.failure != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<RoutineEditorCubit>();
        final draft = state.draft;
        return Scaffold(
          appBar: AppBar(
            title: Text(draft.id == null ? 'New routine' : 'Edit routine'),
            actions: [
              TextButton(
                onPressed: state.isSaving ? null : cubit.save,
                child: const Text('Save'),
              ),
            ],
          ),
          body: state.status.isLoading
              ? const LoadingView()
              : ContentConstraint(
                  maxWidth: 720,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        key: ValueKey('name-${draft.id}'),
                        initialValue: draft.name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        onChanged: cubit.setName,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (var day = 1; day <= 7; day++)
                            FilterChip(
                              label: Text(_weekdayLabels[day - 1]),
                              selected: draft.scheduledWeekdays.contains(day),
                              onSelected: (_) => cubit.toggleWeekday(day),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      for (final (index, item) in draft.exercises.indexed)
                        Card(
                          child: ListTile(
                            title: Text(item.exercise.name),
                            subtitle: Text(
                              '${item.targetSets} sets × ${item.targetReps} reps',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: item.targetSets > 1
                                      ? () => cubit.updateExercise(
                                          index,
                                          item.copyWith(
                                            targetSets: item.targetSets - 1,
                                          ),
                                        )
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => cubit.updateExercise(
                                    index,
                                    item.copyWith(
                                      targetSets: item.targetSets + 1,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => cubit.removeExercise(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add exercise'),
                        onPressed: () async {
                          final exercise = await context.push<Exercise>(
                            '${AppRoutes.exerciseLibrary}?pick=1',
                          );
                          if (exercise != null) cubit.addExercise(exercise);
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
