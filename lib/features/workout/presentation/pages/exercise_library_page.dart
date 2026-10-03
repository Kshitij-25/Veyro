import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/create_custom_exercise.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/exercise_library_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Browse the exercise library. With [selectionMode] a tap pops the chosen
/// exercise back to the caller.
class ExerciseLibraryPage extends StatelessWidget {
  const ExerciseLibraryPage({this.selectionMode = false, super.key});

  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExerciseLibraryCubit, ExerciseLibraryState>(
      listenWhen: (a, b) =>
          (b.lastSyncAdded != null && a.lastSyncAdded != b.lastSyncAdded) ||
          (b.failure != null && a.failure != b.failure),
      listener: (context, state) {
        final cubit = context.read<ExerciseLibraryCubit>();
        final message =
            state.failure?.message ??
            (state.lastSyncAdded == 0
                ? 'Your exercise library is already up to date.'
                : 'Added ${state.lastSyncAdded} exercises.');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        cubit.acknowledgeSync();
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectionMode ? 'Choose exercise' : 'Exercises'),
        actions: [
          BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
            buildWhen: (a, b) => a.isSyncing != b.isSyncing,
            builder: (context, state) => IconButton(
              tooltip: 'Download more exercises',
              icon: const Icon(Icons.cloud_download_outlined),
              onPressed: state.isSyncing
                  ? null
                  : context.read<ExerciseLibraryCubit>().syncRemote,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
            buildWhen: (a, b) => a.isSyncing != b.isSyncing,
            builder: (context, state) => state.isSyncing
                ? const LinearProgressIndicator()
                : const SizedBox(height: 2),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New exercise',
        onPressed: () => _createExercise(context),
        child: const Icon(Icons.add),
      ),
      body: ContentConstraint(
        maxWidth: 720,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                hintText: 'Search',
                leading: const Icon(Icons.search),
                onChanged: context.read<ExerciseLibraryCubit>().search,
              ),
            ),
            SizedBox(
              height: 48,
              child: BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
                buildWhen: (a, b) => a.muscleGroup != b.muscleGroup,
                builder: (context, state) => ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    for (final group in MuscleGroup.values)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(group.label),
                          selected: state.muscleGroup == group,
                          onSelected: (selected) => context
                              .read<ExerciseLibraryCubit>()
                              .filterByMuscleGroup(selected ? group : null),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
                builder: (context, state) {
                  if (state.status.isPending) return const LoadingView();
                  if (state.status.isFailure && state.exercises.isEmpty) {
                    return ErrorView(
                      message:
                          state.failure?.message ?? 'Something went wrong.',
                    );
                  }
                  final exercises = state.visibleExercises;
                  if (exercises.isEmpty) {
                    return const EmptyView(message: 'No exercises found.');
                  }
                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ListTile(
                        leading: exercise.imageUrl == null
                            ? null
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  exercise.imageUrl!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const SizedBox(width: 48, height: 48),
                                ),
                              ),
                        title: Text(exercise.name),
                        subtitle: Text(
                          '${exercise.muscleGroup.label} · ${exercise.equipment.label}',
                        ),
                        trailing: exercise.isCustom && !selectionMode
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => context
                                    .read<ExerciseLibraryCubit>()
                                    .deleteCustom(exercise.id),
                              )
                            : null,
                        onTap: selectionMode
                            ? () => context.pop(exercise)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Downloaded exercises: wger.de, CC-BY-SA 4.0',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createExercise(BuildContext context) async {
    final cubit = context.read<ExerciseLibraryCubit>();
    final controller = TextEditingController();
    var group = MuscleGroup.chest;
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog.adaptive(
          title: const Text('New exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              DropdownButton<MuscleGroup>(
                value: group,
                isExpanded: true,
                items: [
                  for (final g in MuscleGroup.values)
                    DropdownMenuItem(value: g, child: Text(g.label)),
                ],
                onChanged: (g) => setState(() => group = g ?? group),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      await cubit.createCustom(
        CreateCustomExerciseParams(name: controller.text, muscleGroup: group),
      );
    }
  }
}
