import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
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
    final v = context.veyro;
    return Scaffold(
      body: SafeArea(
        child: ContentConstraint(
          maxWidth: 840,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VBackButton(onPressed: () => veyroBack(context)),
                      Row(
                        children: [
                          BlocBuilder<
                            ExerciseLibraryCubit,
                            ExerciseLibraryState
                          >(
                            buildWhen: (a, b) => a.isSyncing != b.isSyncing,
                            builder: (context, state) => VButton(
                              state.isSyncing ? 'Downloading…' : '↓ More',
                              style: VButtonStyle.card,
                              height: 36,
                              onPressed: state.isSyncing
                                  ? null
                                  : context
                                        .read<ExerciseLibraryCubit>()
                                        .syncRemote,
                            ),
                          ),
                          const SizedBox(width: 8),
                          VButton(
                            '+ New',
                            height: 36,
                            onPressed: () => _createExercise(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: VTitle(
                  selectionMode ? 'Choose exercise' : 'Exercises',
                  size: 44,
                ),
              ),
              BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
                buildWhen: (a, b) => a.isSyncing != b.isSyncing,
                builder: (context, state) => state.isSyncing
                    ? const Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: VProgressBar(value: 0.0001),
                      )
                    : const SizedBox.shrink(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: context.read<ExerciseLibraryCubit>().search,
                  style: VeyroText.body(15, color: v.ink),
                  decoration: InputDecoration(
                    hintText: 'Search exercises',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    prefixIcon: Icon(Icons.search, color: v.mute),
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: BlocBuilder<ExerciseLibraryCubit, ExerciseLibraryState>(
                  buildWhen: (a, b) => a.muscleGroup != b.muscleGroup,
                  builder: (context, state) => ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final group in MuscleGroup.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 6, bottom: 10),
                          child: GestureDetector(
                            onTap: () => context
                                .read<ExerciseLibraryCubit>()
                                .filterByMuscleGroup(
                                  state.muscleGroup == group ? null : group,
                                ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: state.muscleGroup == group
                                    ? v.ink
                                    : v.card,
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Text(
                                group.label,
                                style: VeyroText.body(
                                  13,
                                  weight: FontWeight.w600,
                                  color: state.muscleGroup == group
                                      ? v.bg
                                      : v.ink,
                                ),
                              ),
                            ),
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
                    final exercises = state.visibleExercises;
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                      children: [
                        if (state.status.isFailure && state.exercises.isEmpty)
                          VEmpty(
                            state.failure?.message ?? 'Something went wrong.',
                          )
                        else if (exercises.isEmpty)
                          const VEmpty('No exercises found.')
                        else
                          VCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                for (final (i, exercise) in exercises.indexed)
                                  InkWell(
                                    onTap: selectionMode
                                        ? () => context.pop(exercise)
                                        : () => context.go(
                                            AppRoutes.exerciseDetail,
                                            extra: exercise,
                                          ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: i == 0
                                            ? null
                                            : Border(
                                                top: BorderSide(color: v.line),
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          _Thumb(exercise: exercise),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exercise.name,
                                                  style: VeyroText.body(
                                                    15.5,
                                                    weight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  '${exercise.muscleGroup.label} · ${exercise.equipment.label}',
                                                  style: VeyroText.body(
                                                    12,
                                                    color: v.mute,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (exercise.isCustom &&
                                              !selectionMode)
                                            VTextAction(
                                              'Delete',
                                              onPressed: () => context
                                                  .read<ExerciseLibraryCubit>()
                                                  .deleteCustom(exercise.id),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Downloaded exercises: wger.de, CC-BY-SA 4.0',
                            textAlign: TextAlign.center,
                            style: VeyroText.body(11.5, color: v.mute),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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

class _Thumb extends StatelessWidget {
  const _Thumb({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final initials = exercise.name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    final placeholder = Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: v.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(initials, style: VeyroText.display(15, color: v.mute)),
    );
    if (exercise.imageUrl == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        exercise.imageUrl!,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}
