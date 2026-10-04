import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/elapsed_time_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Root of the Workouts tab: current workout, shortcuts and history.
class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          maxWidth: 1100,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            children: [
              const VTitle('Workouts'),
              const SizedBox(height: 14),
              VTwoColumn(
                gap: 12,
                left: [
                  const _CurrentWorkoutCard(),
                  Row(
                    children: [
                      _ShortcutButton('Routines', AppRoutes.routines),
                      const SizedBox(width: 8),
                      _ShortcutButton('Exercises', AppRoutes.exerciseLibrary),
                      const SizedBox(width: 8),
                      _ShortcutButton('Records', AppRoutes.personalRecords),
                    ],
                  ),
                  const _Explore(),
                ],
                right: const [
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: VLabel('History'),
                  ),
                  _History(),
                ],
                compact: [
                  const _CurrentWorkoutCard(),
                  Row(
                    children: [
                      _ShortcutButton('Routines', AppRoutes.routines),
                      const SizedBox(width: 8),
                      _ShortcutButton('Exercises', AppRoutes.exerciseLibrary),
                      const SizedBox(width: 8),
                      _ShortcutButton('Records', AppRoutes.personalRecords),
                    ],
                  ),
                  const _Explore(),
                  const Padding(
                    padding: EdgeInsets.only(left: 2, top: 6),
                    child: VLabel('History'),
                  ),
                  const _History(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton(this.label, this.route);

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VButton(
        label,
        style: VButtonStyle.card,
        height: 50,
        radius: 16,
        onPressed: () => context.push(route),
      ),
    );
  }
}

class _CurrentWorkoutCard extends StatelessWidget {
  const _CurrentWorkoutCard();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocBuilder<ActiveWorkoutCubit, ActiveWorkoutState>(
      builder: (context, state) {
        final workout = state.workout;
        if (workout != null) {
          return VCard(
            color: v.acc,
            radius: 26,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VLabel(
                  'Workout in progress',
                  color: VeyroColors.onAccent,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        workout.name.toUpperCase(),
                        style: VeyroText.display(
                          34,
                          color: VeyroColors.onAccent,
                        ),
                      ),
                    ),
                    ElapsedTimeText(
                      since: workout.startedAt,
                      style: VeyroText.display(
                        44,
                        color: VeyroColors.onAccent,
                        height: .9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: VeyroColors.onAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => context.push(AppRoutes.activeWorkout),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          );
        }
        return VCard(
          color: v.ink,
          radius: 26,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NO WORKOUT IN PROGRESS',
                style: VeyroText.display(30, color: v.bg),
              ),
              const SizedBox(height: 12),
              VButton(
                'Start empty workout',
                height: 54,
                radius: 16,
                expand: true,
                onPressed: state.isBusy
                    ? null
                    : () async {
                        final cubit = context.read<ActiveWorkoutCubit>();
                        await cubit.beginWorkout();
                        if (context.mounted) {
                          context.go(AppRoutes.activeWorkout);
                        }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _History extends StatelessWidget {
  const _History();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    return BlocBuilder<WorkoutHistoryCubit, WorkoutHistoryState>(
      builder: (context, state) {
        if (state.status.isPending) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (state.status.isFailure) {
          return _Message(state.failure?.message ?? 'Something went wrong.');
        }
        if (state.workouts.isEmpty) {
          return const _Message('No completed workouts yet.');
        }
        return VCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < state.workouts.length; i++)
                _HistoryRow(
                  workout: state.workouts[i],
                  units: units,
                  topBorder: i == 0 ? null : BorderSide(color: v.line),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.workout,
    required this.units,
    required this.topBorder,
  });

  final Workout workout;
  final UnitSystem units;
  final BorderSide? topBorder;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final minutes = workout.durationAt(DateTime.now()).inMinutes;
    final volume = UnitConverter.weightToDisplay(
      workout.totalVolumeKg,
      units,
    ).round();
    return InkWell(
      onTap: () => context.push(AppRoutes.workoutDetail(workout.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(top: topBorder ?? BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: VeyroText.body(16, weight: FontWeight.w700),
                  ),
                  Text(
                    '${DateFormat.MMMd().format(workout.startedAt)} · $minutes min',
                    style: VeyroText.body(12.5, color: v.mute),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$volume', style: VeyroText.display(24)),
                Text(
                  '${units.weightUnit} volume',
                  style: VeyroText.body(11, color: v.mute),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => VCard(
    padding: const EdgeInsets.all(28),
    child: Center(
      child: Text(text, style: VeyroText.body(14, color: context.veyro.mute)),
    ),
  );
}

class _Explore extends StatelessWidget {
  const _Explore();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final tiles = [
      ('Programs & sessions', 'Guided plans', AppRoutes.discover),
      ('Calendar', 'Month view', AppRoutes.calendar),
      ('Timers', 'HIIT, stopwatch', AppRoutes.timers),
      ('Calculators', '1RM, plates, TDEE', AppRoutes.tools),
      ('Cardio', 'Run, ride, hike', AppRoutes.activity),
      ('Mind & mobility', 'Breathing, stretching', AppRoutes.mind),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(2, 6, 0, 8),
          child: VLabel('Explore'),
        ),
        VGrid2(
          children: [
            for (final t in tiles)
              VCard(
                padding: const EdgeInsets.all(14),
                onTap: () => context.push(t.$3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.$1.toUpperCase(), style: VeyroText.display(22)),
                    const SizedBox(height: 3),
                    Text(t.$2, style: VeyroText.body(12, color: v.mute)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
