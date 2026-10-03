import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/routines/presentation/cubit/routines_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocConsumer<RoutinesCubit, RoutinesState>(
      listenWhen: (previous, current) =>
          current.failure != null && current.failure != previous.failure,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
      builder: (context, state) {
        final Widget? message = state.status.isPending
            ? const LoadingView()
            : state.status.isFailure && state.routines.isEmpty
            ? VEmpty(state.failure?.message ?? 'Something went wrong.')
            : state.routines.isEmpty
            ? const VEmpty('No routines yet.')
            : null;
        return VSubPage(
          title: 'Routines',
          action: VButton(
            '+ New',
            height: 36,
            onPressed: () => context.go(AppRoutes.routineEditor()),
          ),
          children: [
            ?message,
            for (final routine in state.routines)
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () =>
                          context.go(AppRoutes.routineEditor(routine.id)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  routine.name.toUpperCase(),
                                  style: VeyroText.display(30),
                                ),
                              ),
                              Text(
                                '${routine.exercises.length} exercises',
                                style: VeyroText.body(12, color: v.mute),
                              ),
                            ],
                          ),
                          if (routine.scheduledWeekdays.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                [
                                  for (final day
                                      in routine.scheduledWeekdays.toList()
                                        ..sort())
                                    _weekdayLabels[day - 1],
                                ].join(', '),
                                style: VeyroText.body(13, color: v.mute),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: VButton(
                            'Start workout',
                            style: VButtonStyle.ink,
                            height: 44,
                            radius: 14,
                            onPressed: () async {
                              final started = await context
                                  .read<RoutinesCubit>()
                                  .startWorkout(routine.id);
                              if (started && context.mounted) {
                                context.go(AppRoutes.activeWorkout);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        VTextAction(
                          'Delete',
                          onPressed: () =>
                              context.read<RoutinesCubit>().delete(routine.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
