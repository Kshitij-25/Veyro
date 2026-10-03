import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Guided programs and classes (sample catalogue).
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _tab = 'Programs';
  String _filter = 'All';

  static const _classes = [
    ('Full Body Burn', 'HIIT', 30, 'Intermediate', 'Dana K.'),
    ('Upper Body Strength', 'Strength', 45, 'Intermediate', 'Marcus L.'),
    ('Morning Flow', 'Yoga', 20, 'Beginner', 'Ines P.'),
    ('Core Express', 'Core', 12, 'All levels', 'Dana K.'),
    ('Leg Day Builder', 'Strength', 50, 'Advanced', 'Marcus L.'),
    ('Mobility Reset', 'Mobility', 15, 'Beginner', 'Ines P.'),
    ('Tempo Run Coach', 'Cardio', 35, 'Intermediate', 'Theo W.'),
    ('Low Impact Cardio', 'Cardio', 25, 'Beginner', 'Theo W.'),
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) {
        final active = store.programIndex;
        final classes = _classes
            .where((c) => _filter == 'All' || c.$2 == _filter)
            .toList();
        return VSubPage(
          title: 'Programs\n& classes',
          maxWidth: 840,
          children: [
            VTabs<String>(
              options: const {'Programs': 'Programs', 'Classes': 'Classes'},
              selected: _tab,
              onChanged: (t) => setState(() => _tab = t),
            ),
            if (_tab == 'Programs') ...[
              if (active != null)
                VCard(
                  color: v.acc,
                  radius: 26,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VLabel(
                        'Active program',
                        color: VeyroColors.onAccent,
                      ),
                      Text(
                        WellnessStore.programs[active].name.toUpperCase(),
                        style: VeyroText.display(
                          34,
                          color: VeyroColors.onAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'Week ${store.programWeek} of ${WellnessStore.programs[active].weeks} · Next: Day 2 · Pull',
                          style: VeyroText.body(
                            13,
                            color: VeyroColors.onAccent,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value:
                              store.programWeek /
                              WellnessStore.programs[active].weeks,
                          minHeight: 8,
                          backgroundColor: VeyroColors.onAccent.withValues(
                            alpha: .18,
                          ),
                          valueColor: const AlwaysStoppedAnimation(
                            VeyroColors.onAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              VGrid2(
                gap: 10,
                children: [
                  for (final (i, p) in WellnessStore.programs.indexed)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: v.card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: active == i ? v.acc : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            p.name.toUpperCase(),
                            style: VeyroText.display(28),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${p.weeks} weeks · ${p.daysPerWeek} days/wk · ${p.level}',
                            style: VeyroText.body(12.5, color: v.mute),
                          ),
                          const SizedBox(height: 8),
                          Text(p.blurb, style: VeyroText.body(14)),
                          const SizedBox(height: 8),
                          VButton(
                            active == i ? 'Leave' : 'Enroll',
                            style: active == i
                                ? VButtonStyle.soft
                                : VButtonStyle.ink,
                            height: 42,
                            radius: 14,
                            expand: true,
                            onPressed: () => store.toggleProgram(i),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ] else ...[
              VChipRow<String>(
                options: {
                  for (final c in [
                    'All',
                    'Strength',
                    'HIIT',
                    'Yoga',
                    'Cardio',
                    'Mobility',
                    'Core',
                  ])
                    c: c,
                },
                selected: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
              VGrid2(
                gap: 10,
                children: [
                  for (final c in classes)
                    VCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 84,
                            child: VPlaceholder(c.$2, height: 84, radius: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.$1.toUpperCase(),
                                  style: VeyroText.display(22),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    3,
                                    0,
                                    8,
                                  ),
                                  child: Text(
                                    '${c.$3} min · ${c.$4} · ${c.$5}',
                                    style: VeyroText.body(12.5, color: v.mute),
                                  ),
                                ),
                                VButton(
                                  'Start',
                                  style: VButtonStyle.ink,
                                  height: 34,
                                  onPressed: () async {
                                    final cubit = context
                                        .read<ActiveWorkoutCubit>();
                                    await cubit.beginWorkout(name: c.$1);
                                    if (context.mounted) {
                                      context.go(AppRoutes.activeWorkout);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
