import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/routines/presentation/cubit/routines_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New routine',
        onPressed: () => context.go(AppRoutes.routineEditor()),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<RoutinesCubit, RoutinesState>(
        listenWhen: (previous, current) =>
            current.failure != null && current.failure != previous.failure,
        listener: (context, state) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message))),
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          if (state.status.isFailure && state.routines.isEmpty) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
            );
          }
          if (state.routines.isEmpty) {
            return const EmptyView(message: 'No routines yet.');
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              children: [
                for (final routine in state.routines)
                  ListTile(
                    title: Text(routine.name),
                    subtitle: Text(
                      [
                        '${routine.exercises.length} exercises',
                        if (routine.scheduledWeekdays.isNotEmpty)
                          [
                            for (final day
                                in routine.scheduledWeekdays.toList()..sort())
                              _weekdayLabels[day - 1],
                          ].join(', '),
                      ].join(' · '),
                    ),
                    onTap: () =>
                        context.go(AppRoutes.routineEditor(routine.id)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Start workout',
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () async {
                            final started = await context
                                .read<RoutinesCubit>()
                                .startWorkout(routine.id);
                            if (started && context.mounted) {
                              context.go(AppRoutes.activeWorkout);
                            }
                          },
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<RoutinesCubit>().delete(routine.id),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
