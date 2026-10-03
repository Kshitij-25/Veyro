import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
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
        final v = context.veyro;
        return VSubPage(
          title: 'Routine',
          gap: 12,
          action: VButton(
            'Save',
            height: 36,
            onPressed: state.isSaving ? null : cubit.save,
          ),
          children: [
            if (state.status.isLoading) const LoadingView(),
            TextFormField(
              key: ValueKey('name-${draft.id}'),
              initialValue: draft.name,
              style: VeyroText.body(17, weight: FontWeight.w600, color: v.ink),
              decoration: const InputDecoration(
                hintText: 'Routine name',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
              onChanged: cubit.setName,
            ),
            VCard(
              radius: 20,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VLabel('Planned days'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var day = 1; day <= 7; day++)
                        GestureDetector(
                          onTap: () => cubit.toggleWeekday(day),
                          child: Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: draft.scheduledWeekdays.contains(day)
                                  ? v.acc
                                  : v.bg,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _weekdayLabels[day - 1],
                              style: VeyroText.body(
                                13,
                                weight: FontWeight.w700,
                                color: draft.scheduledWeekdays.contains(day)
                                    ? VeyroColors.onAccent
                                    : v.ink,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            for (final (index, item) in draft.exercises.indexed)
              VCard(
                radius: 20,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.exercise.name.toUpperCase(),
                            style: VeyroText.display(22),
                          ),
                        ),
                        VTextAction(
                          'Remove',
                          onPressed: () => cubit.removeExercise(index),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Target sets',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                        Row(
                          children: [
                            _RoundStepper(
                              icon: Icons.remove,
                              onPressed: item.targetSets > 1
                                  ? () => cubit.updateExercise(
                                      index,
                                      item.copyWith(
                                        targetSets: item.targetSets - 1,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${item.targetSets}',
                                textAlign: TextAlign.center,
                                style: VeyroText.display(26),
                              ),
                            ),
                            _RoundStepper(
                              icon: Icons.add,
                              onPressed: () => cubit.updateExercise(
                                index,
                                item.copyWith(targetSets: item.targetSets + 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${item.targetReps} reps',
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
            VButton(
              '+ Add exercise',
              style: VButtonStyle.ink,
              height: 50,
              radius: 16,
              expand: true,
              onPressed: () async {
                final exercise = await context.push<Exercise>(
                  '${AppRoutes.exerciseLibrary}?pick=1',
                );
                if (exercise != null) cubit.addExercise(exercise);
              },
            ),
          ],
        );
      },
    );
  }
}

class _RoundStepper extends StatelessWidget {
  const _RoundStepper({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 38,
    height: 38,
    child: IconButton.filled(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: context.veyro.bg,
        foregroundColor: context.veyro.ink,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
    ),
  );
}
