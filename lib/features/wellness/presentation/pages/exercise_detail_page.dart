import 'dart:async';
import 'dart:math' as math;

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_workout_history.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Exercise detail: muscles, description and progress from your history.
class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({required this.exercise, super.key});

  final Exercise exercise;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

/// One finished workout's numbers for the exercise.
class _Session {
  const _Session(this.at, this.value, this.volumeKg, this.bestSet);

  final DateTime at;

  /// Trend value: estimated 1RM, reps, seconds or metres by tracking type.
  final double value;
  final double volumeKg;
  final String bestSet;
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  List<_Session> _sessions = const [];
  StreamSubscription<List<Workout>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = getIt<WatchWorkoutHistory>()(const NoParams()).listen((workouts) {
      if (mounted) setState(() => _sessions = _build(workouts));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  List<_Session> _build(List<Workout> workouts) {
    final type = widget.exercise.trackingType;
    final out = <_Session>[];
    for (final w in workouts) {
      final sets = [
        for (final e in w.exercises)
          if (e.exercise.id == widget.exercise.id)
            ...e.sets.where((x) => x.isCompleted && !x.isWarmup),
      ];
      if (sets.isEmpty) continue;
      double value = 0;
      var best = '';
      var volume = 0.0;
      for (final x in sets) {
        final kg = x.weightKg ?? 0;
        final reps = x.reps ?? 0;
        volume += x.volumeKg;
        final v = switch (type) {
          ExerciseTrackingType.weightAndReps =>
            reps <= 1 ? kg : kg * (1 + reps / 30),
          ExerciseTrackingType.repsOnly => reps.toDouble(),
          ExerciseTrackingType.duration => (x.durationSeconds ?? 0).toDouble(),
          ExerciseTrackingType.distanceAndDuration => x.distanceMeters ?? 0,
        };
        if (v > value) {
          value = v;
          best = '$kg|$reps';
        }
      }
      if (value > 0) {
        out.add(_Session(w.startedAt, value, volume, best));
      }
    }
    out.sort((a, b) => a.at.compareTo(b.at));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final ex = widget.exercise;
    final muscle = ex.muscleGroup.label;
    final type = ex.trackingType;
    final s = _sessions;
    final trend = [for (final x in s) x.value];
    String fmt(double value) => switch (type) {
      ExerciseTrackingType.weightAndReps =>
        '${units.fw(value)} ${units.weightUnit}',
      ExerciseTrackingType.repsOnly => '${value.round()} reps',
      ExerciseTrackingType.duration => clockText(value),
      ExerciseTrackingType.distanceAndDuration =>
        '${units.fd(value / 1000, 2)} ${units.distanceUnit}',
    };
    final topValue = s.isEmpty ? 0.0 : trend.reduce(math.max);
    final bestVolume = s.isEmpty
        ? 0.0
        : s.map((x) => x.volumeKg).reduce(math.max);
    final heaviest = s.isEmpty
        ? 0.0
        : s
              .map((x) => double.tryParse(x.bestSet.split('|').first) ?? 0)
              .reduce(math.max);
    final stats = <(String, String)>[
      if (s.isNotEmpty) ...[
        if (type == ExerciseTrackingType.weightAndReps) ...[
          ('Heaviest set', '${units.fw(heaviest)} ${units.weightUnit}'),
          ('Estimated 1RM', fmt(topValue)),
          (
            'Best volume',
            '${thousands(bestVolume * units.kgFactor)} ${units.weightUnit}',
          ),
        ] else
          (
            switch (type) {
              ExerciseTrackingType.repsOnly => 'Most reps',
              ExerciseTrackingType.duration => 'Longest set',
              _ => 'Longest distance',
            },
            fmt(topValue),
          ),
        ('Sessions', '${s.length}'),
        ('Last done', DateFormat('MMM d, yyyy').format(s.last.at)),
      ],
    ];
    final trendLabel = switch (type) {
      ExerciseTrackingType.weightAndReps => 'Estimated 1RM trend',
      ExerciseTrackingType.repsOnly => 'Best reps per session',
      ExerciseTrackingType.duration => 'Longest set per session',
      ExerciseTrackingType.distanceAndDuration => 'Distance per session',
    };
    return VSubPage(
      title: ex.name,
      maxWidth: 720,
      children: [
        if (ex.imageUrl != null && ex.imageUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              ex.imageUrl!,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        Text(
          '$muscle · ${ex.equipment.label}',
          style: VeyroText.body(13, color: v.mute),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VLabel('Muscle'),
              const SizedBox(height: 8),
              _Pill(muscle, filled: true),
            ],
          ),
        ),
        if (ex.description != null && ex.description!.trim().isNotEmpty)
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VLabel('How to'),
                const SizedBox(height: 6),
                Text(
                  ex.description!
                      .replaceAll(RegExp('<[^>]*>'), ' ')
                      .replaceAll(RegExp(r'\s+'), ' ')
                      .trim(),
                  style: VeyroText.body(14.5, height: 1.4),
                ),
              ],
            ),
          ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VLabel(trendLabel),
              const SizedBox(height: 8),
              if (s.length >= 2)
                VLinePlot(values: trend, height: 70)
              else
                Text(
                  s.isEmpty
                      ? 'Log this exercise in a workout to see your progress.'
                      : 'Log it once more to see a trend.',
                  style: VeyroText.body(13, color: v.mute),
                ),
              for (final b in stats)
                VKeyValueRow(
                  label: b.$1,
                  height: 38,
                  value: Text(b.$2, style: VeyroText.display(20)),
                ),
            ],
          ),
        ),
        VButton(
          'Add to workout',
          height: 52,
          radius: 16,
          expand: true,
          onPressed: () async {
            final cubit = context.read<ActiveWorkoutCubit>();
            if (cubit.state.workout == null) await cubit.beginWorkout();
            await cubit.addExercise(ex);
            if (context.mounted) context.go(AppRoutes.activeWorkout);
          },
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {this.filled = false});

  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? v.acc : v.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: VeyroText.body(
          12.5,
          weight: filled ? FontWeight.w700 : FontWeight.w600,
          color: filled ? VeyroColors.onAccent : v.ink,
        ),
      ),
    );
  }
}
