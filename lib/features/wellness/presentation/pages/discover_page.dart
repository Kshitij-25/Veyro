import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/programs/data/seed/training_catalogue.dart';
import 'package:fitness_trakcer/features/programs/domain/entities/training_plan.dart';
import 'package:fitness_trakcer/features/programs/presentation/cubit/programs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Multi-week programs and ready-made sessions, built from the exercise
/// library. Starting one opens a pre-filled workout.
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String _tab = 'Programs';
  String _filter = 'All';

  Future<void> _start(Future<bool> Function() action) async {
    final started = await action();
    if (started && mounted) context.go(AppRoutes.activeWorkout);
  }

  Future<void> _enroll(TrainingProgram p, ProgramProgress? active) async {
    final cubit = context.read<ProgramsCubit>();
    if (active != null && active.program.id != p.id) {
      final ok = await showVeyroConfirm(
        context,
        title: 'Switch program?',
        message:
            'You\'ll leave ${active.program.name} and start ${p.name} from week 1. Workouts you already logged stay in your history.',
        confirmLabel: 'Switch',
      );
      if (!ok) return;
    }
    await cubit.enroll(p.id);
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocConsumer<ProgramsCubit, ProgramsState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.failure!.message)));
        context.read<ProgramsCubit>().clearFailure();
      },
      builder: (context, state) {
        final cubit = context.read<ProgramsCubit>();
        final active = state.progress;
        final sessions = quickSessions
            .where((s) => _filter == 'All' || s.category == _filter)
            .toList();
        return VSubPage(
          title: 'Programs\n& sessions',
          maxWidth: 840,
          children: [
            VTabs<String>(
              options: const {'Programs': 'Programs', 'Sessions': 'Sessions'},
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
                        active.program.name.toUpperCase(),
                        style: VeyroText.display(
                          34,
                          color: VeyroColors.onAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          active.isComplete
                              ? 'Complete · ${active.sessionsDone} sessions done'
                              : 'Week ${active.week} of ${active.program.weeks} · Next: Day ${active.nextDayIndex + 1} · ${active.nextDay.name}',
                          style: VeyroText.body(
                            13,
                            color: VeyroColors.onAccent,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: active.fraction,
                          minHeight: 8,
                          backgroundColor: VeyroColors.onAccent.withValues(
                            alpha: .18,
                          ),
                          valueColor: const AlwaysStoppedAnimation(
                            VeyroColors.onAccent,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${active.sessionsDone} of ${active.total} sessions',
                          style: VeyroText.body(
                            12,
                            color: VeyroColors.onAccent,
                          ),
                        ),
                      ),
                      if (!active.isComplete) ...[
                        const SizedBox(height: 12),
                        VButton(
                          state.isBusy
                              ? 'Starting…'
                              : 'Start Day ${active.nextDayIndex + 1}',
                          style: VButtonStyle.ink,
                          expand: true,
                          onPressed: state.isBusy
                              ? null
                              : () => _start(cubit.startNextDay),
                        ),
                      ],
                    ],
                  ),
                ),
              VGrid2(
                gap: 10,
                children: [
                  for (final p in trainingPrograms)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: v.card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: active?.program.id == p.id
                              ? v.acc
                              : Colors.transparent,
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
                          const SizedBox(height: 6),
                          Text(
                            p.days.map((d) => d.name).toSet().join(' · '),
                            style: VeyroText.body(12, color: v.mute),
                          ),
                          const SizedBox(height: 10),
                          VButton(
                            active?.program.id == p.id ? 'Leave' : 'Enroll',
                            style: active?.program.id == p.id
                                ? VButtonStyle.soft
                                : VButtonStyle.ink,
                            height: 42,
                            radius: 14,
                            expand: true,
                            onPressed: () => active?.program.id == p.id
                                ? cubit.leave()
                                : _enroll(p, active),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Text(
                'Programs set the exercises, sets and reps for each day. You choose the weights, and each finished session moves you along.',
                textAlign: TextAlign.center,
                style: VeyroText.body(12, color: v.mute, height: 1.4),
              ),
            ] else ...[
              VChipRow<String>(
                options: {
                  for (final c in ['All', 'Strength', 'HIIT', 'Cardio', 'Core'])
                    c: c,
                },
                selected: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
              VGrid2(
                gap: 10,
                children: [
                  for (final s in sessions)
                    VCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            s.name.toUpperCase(),
                            style: VeyroText.display(24),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
                            child: Text(
                              '${s.category} · ~${s.minutes} min · ${s.level} · ${s.exercises.length} exercise${s.exercises.length == 1 ? '' : 's'}',
                              style: VeyroText.body(12.5, color: v.mute),
                            ),
                          ),
                          VButton(
                            'Start',
                            style: VButtonStyle.ink,
                            height: 40,
                            expand: true,
                            onPressed: state.isBusy
                                ? null
                                : () => _start(() => cubit.startSession(s)),
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
