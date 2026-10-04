import 'package:fitness_trakcer/core/share/share_summary.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/workout_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

String _shareText(Workout w, UnitSystem units) {
  final b = StringBuffer(w.name)
    ..writeln()
    ..writeln(
      '${DateFormat('EEEE, MMM d').format(w.startedAt)} · '
      '${w.durationAt(DateTime.now()).inMinutes} min',
    );
  if (w.totalVolumeKg > 0) {
    b.writeln(
      'Volume: ${UnitConverter.weightToDisplay(w.totalVolumeKg, units).round()} '
      '${units.weightUnit}',
    );
  }
  for (final e in w.exercises) {
    final sets = e.sets.where((s) => s.isCompleted).toList();
    if (sets.isEmpty) continue;
    b
      ..writeln()
      ..writeln(e.exercise.name);
    for (final s in sets) {
      b.writeln(
        [
          if (s.weightKg != null) units.formatWeight(s.weightKg!),
          if (s.reps != null) '× ${s.reps}',
          if (s.distanceMeters != null) units.formatDistance(s.distanceMeters!),
          if (s.durationSeconds != null)
            Duration(seconds: s.durationSeconds!).clock,
        ].join(' '),
      );
    }
  }
  b
    ..writeln()
    ..write('Logged with Veyro');
  return b.toString();
}

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return BlocBuilder<WorkoutDetailCubit, WorkoutDetailState>(
      builder: (context, state) {
        if (state.status.isPending) {
          return const Scaffold(body: LoadingView());
        }
        final workout = state.workout;
        if (workout == null) {
          return VSubPage(
            title: 'Workout',
            children: [VEmpty(state.failure?.message ?? 'Workout not found.')],
          );
        }
        Widget stat(String value, String caption) => Expanded(
          child: VCard(
            radius: 18,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: VeyroText.display(34)),
                Text(caption, style: VeyroText.body(11, color: v.mute)),
              ],
            ),
          ),
        );
        return VSubPage(
          title: workout.name,
          action: Builder(
            builder: (context) => IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: v.card,
                foregroundColor: v.ink,
              ),
              tooltip: 'Share',
              onPressed: () =>
                  shareSummary(context, _shareText(workout, units)),
              icon: Icon(Icons.adaptive.share, size: 20),
            ),
          ),
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(workout.startedAt).toUpperCase(),
              style: VeyroText.label(color: v.mute),
            ),
            Row(
              children: [
                stat(
                  '${workout.durationAt(DateTime.now()).inMinutes}',
                  'minutes',
                ),
                const SizedBox(width: 8),
                stat(
                  UnitConverter.weightToDisplay(
                    workout.totalVolumeKg,
                    units,
                  ).round().toString(),
                  '${units.weightUnit} volume',
                ),
                const SizedBox(width: 8),
                stat('${workout.caloriesBurned?.round() ?? 0}', 'kcal (est.)'),
              ],
            ),
            _MusclesCard(workout: workout),
            for (final entry in workout.exercises)
              VCard(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.exercise.name.toUpperCase(),
                      style: VeyroText.display(22),
                    ),
                    const SizedBox(height: 4),
                    for (final set in entry.sets)
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: v.line)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: Text(
                                '${set.position + 1}',
                                style: VeyroText.display(17, color: v.mute),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                [
                                  if (set.weightKg != null)
                                    units.formatWeight(set.weightKg!),
                                  if (set.reps != null) '× ${set.reps}',
                                  if (set.distanceMeters != null)
                                    units.formatDistance(set.distanceMeters!),
                                  if (set.durationSeconds != null)
                                    Duration(seconds: set.durationSeconds!)
                                        .clock,
                                ].join(' '),
                                style: VeyroText.display(
                                  20,
                                  color: v.ink,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
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

class _MusclesCard extends StatelessWidget {
  const _MusclesCard({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final counts = <String, int>{};
    for (final e in workout.exercises) {
      final done = e.sets.where((s) => s.isCompleted).length;
      final sets = done == 0 ? e.sets.length : done;
      counts.update(
        e.exercise.muscleGroup.label,
        (c) => c + sets,
        ifAbsent: () => sets,
      );
    }
    if (counts.isEmpty) return const SizedBox.shrink();
    final top = counts.values.reduce((a, b) => a > b ? a : b);
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Muscles worked'),
          for (final e in entries)
            SizedBox(
              height: 34,
              child: Row(
                children: [
                  SizedBox(
                    width: 84,
                    child: Text(
                      e.key,
                      style: VeyroText.body(13.5, weight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: VProgressBar(value: e.value / top, height: 8),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${e.value} sets',
                      textAlign: TextAlign.right,
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
