import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Exercise detail: muscles, how-to and trend (trend values are sample data).
class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({required this.exercise, super.key});

  final Exercise exercise;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  bool _fav = false;

  static const _secondary = {
    'Chest': 'Triceps, Shoulders',
    'Back': 'Biceps, Rear delts',
    'Shoulders': 'Triceps, Traps',
    'Quads': 'Glutes, Core',
    'Hamstrings': 'Glutes, Lower back',
    'Biceps': 'Forearms',
    'Triceps': 'Chest, Shoulders',
    'Core': 'Obliques',
  };

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final ex = widget.exercise;
    final muscle = ex.muscleGroup.label;
    final bodyweight = ex.equipment.label.toLowerCase().contains('body');
    const base = 80.0;
    final e1 = base * (1 + 8 / 30);
    final trend = bodyweight
        ? <double>[6, 7, 7, 8, 8, 9, 10, 10]
        : <double>[
            for (final m in [.8, .83, .85, .88, .9, .93, .97, 1]) e1 * m,
          ];
    final best = bodyweight
        ? const [
            ('Most reps', '10'),
            ('Best session', '3 × 8'),
            ('Last done', '—'),
          ]
        : [
            ('Heaviest set', '${units.fw(base * 1.1)} ${units.weightUnit} × 5'),
            ('Estimated 1RM', '${units.fw(e1)} ${units.weightUnit}'),
            (
              'Best volume',
              '${thousands(base * 1.05 * units.kgFactor * 24)} ${units.weightUnit}',
            ),
          ];
    return VSubPage(
      title: ex.name,
      maxWidth: 720,
      action: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: v.card,
          foregroundColor: v.acc,
        ),
        onPressed: () => setState(() => _fav = !_fav),
        icon: Icon(_fav ? Icons.star : Icons.star_border),
      ),
      children: [
        const VPlaceholder('exercise demo', height: 210),
        Text(
          '$muscle · ${ex.equipment.label}',
          style: VeyroText.body(13, color: v.mute),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VLabel('Muscles'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _Pill(muscle, filled: true),
                  _Pill(_secondary[muscle] ?? 'Stabilisers'),
                ],
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('How to'),
              for (final (i, t) in [
                'Set up with a stable stance and brace your core.',
                'Lower under control through the full range of motion.',
                'Drive back up, keeping the path close to your body.',
                'Exhale at the top and reset before the next rep.',
              ].indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: v.bg,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: VeyroText.body(12, weight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t,
                          style: VeyroText.body(14.5, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('Estimated 1RM trend'),
              const SizedBox(height: 8),
              VLinePlot(values: trend, height: 70),
              for (final b in best)
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
