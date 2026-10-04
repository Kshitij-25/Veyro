import 'dart:math' as math;

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/widgets/elapsed_time_text.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/request_health_access.dart';
import 'package:fitness_trakcer/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/start_workout_from_routine.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/habits_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Root of the Home tab: today at a glance.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const _stepGoalFallback = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final summary = state.summary;
            if (summary == null) {
              return state.status.isFailure
                  ? ErrorView(
                      message:
                          state.failure?.message ?? 'Something went wrong.',
                      onRetry: context.read<DashboardCubit>().load,
                    )
                  : const LoadingView();
            }
            return ContentConstraint(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  final cubit = context.read<DashboardCubit>();
                  await context.read<HealthSyncCubit>().syncIfStale(
                    maxAge: Duration.zero,
                  );
                  await cubit.load();
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  children: [
                    VTitle(
                      'Today',
                      kicker: DateFormat('EEEE, MMM d').format(summary.date),
                      trailing: _ProfileButton(
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _QuickChips(),
                    const SizedBox(height: 12),
                    VTwoColumn(
                      left: [
                        _ReadinessCard(summary: summary),
                        _StepsHero(summary: summary),
                        _TrainingCard(summary: summary),
                        _CoachCard(summary: summary),
                      ],
                      right: [
                        const _FoodRow(),
                        const _HabitsCard(),
                        _ReportCard(summary: summary),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _WeightCard(summary: summary)),
                              const SizedBox(width: 12),
                              Expanded(child: _GoalsCard(summary: summary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Tooltip(
      message: 'Profile & settings',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: v.card, shape: BoxShape.circle),
          child: Icon(Icons.person_outline, color: v.ink),
        ),
      ),
    );
  }
}

class _StepsHero extends StatelessWidget {
  const _StepsHero({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final activity = summary.activity;
    final goal = summary.goals
        .where((g) => g.goal.type.name == 'dailySteps')
        .firstOrNull;
    final target = goal?.goal.targetValue ?? DashboardPage._stepGoalFallback;
    final fraction = (activity.steps / target).clamp(0.0, 1.0);
    final distance = UnitConverter.distanceToDisplay(
      activity.distanceMeters,
      units,
    );
    return VCard(
      color: v.ink,
      radius: 26,
      padding: const EdgeInsets.all(18),
      onTap: () => context.push(AppRoutes.activity),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _RingPainter(fraction, v.acc),
              child: Center(
                child: Text(
                  '${(fraction * 100).round()}%',
                  style: VeyroText.display(26, color: v.bg),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VLabel('Steps today', color: v.bg.withValues(alpha: .6)),
                Text(
                  NumberFormat.decimalPattern().format(activity.steps),
                  style: VeyroText.display(54, color: v.bg, height: .95),
                ),
                Text(
                  '${distance.toStringAsFixed(1)} ${units.distanceUnit} · '
                  '${activity.activeCaloriesKcal.round()} kcal',
                  style: VeyroText.body(13, color: v.bg.withValues(alpha: .7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction, this.color);

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0x4D808080);
    canvas.drawArc(arc, 0, math.pi * 2, false, base);
    canvas.drawArc(
      arc,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      base
        ..color = color
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color;
}

class _TrainingCard extends StatelessWidget {
  const _TrainingCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final active = summary.activeWorkout;
    final planned = summary.todaysRoutines.firstOrNull;
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const VLabel('Training'),
              InkWell(
                onTap: () => context.go(AppRoutes.workouts),
                child: Text(
                  '${summary.workoutsThisWeek} this week ›',
                  style: VeyroText.body(13, color: v.mute),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (active != null)
            Material(
              color: v.acc,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push(AppRoutes.activeWorkout),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VLabel(
                            'In progress',
                            color: VeyroColors.onAccent,
                          ),
                          Text(
                            active.name.toUpperCase(),
                            style: VeyroText.display(
                              26,
                              color: VeyroColors.onAccent,
                            ),
                          ),
                        ],
                      ),
                      ElapsedTimeText(
                        since: active.startedAt,
                        style: VeyroText.display(
                          30,
                          color: VeyroColors.onAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Text(
              'No workout in progress',
              style: VeyroText.body(14, color: v.mute),
            ),
          if (planned != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Planned today',
                      style: VeyroText.body(12, color: v.mute),
                    ),
                    Text(
                      planned.name,
                      style: VeyroText.body(18, weight: FontWeight.w700),
                    ),
                  ],
                ),
                VButton(
                  'Start',
                  style: VButtonStyle.ink,
                  onPressed: () => context.push(AppRoutes.routines),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final kg = summary.latestWeightKg;
    return VCard(
      onTap: () => context.go(AppRoutes.progress),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VLabel('Weight'),
          if (kg == null)
            Text('—', style: VeyroText.display(50))
          else
            Text.rich(
              TextSpan(
                text: UnitConverter.weightToDisplay(
                  kg,
                  units,
                ).toStringAsFixed(1),
                children: [
                  TextSpan(
                    text: ' ${units.weightUnit}',
                    style: VeyroText.display(20, color: v.mute),
                  ),
                ],
              ),
              style: VeyroText.display(50),
            ),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  const _GoalsCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return VCard(
      onTap: () => context.push(AppRoutes.goals),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VLabel('Goals'),
          const SizedBox(height: 9),
          if (summary.goals.isEmpty)
            Text('No goals yet', style: VeyroText.body(12, color: v.mute)),
          for (final g in summary.goals.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          g.goal.type.label,
                          overflow: TextOverflow.ellipsis,
                          style: VeyroText.body(11.5, weight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${(g.fraction * 100).round()}%',
                        style: VeyroText.body(11.5, color: v.mute),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  VProgressBar(value: g.fraction),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickChips extends StatelessWidget {
  const _QuickChips();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final chips = <(String, VoidCallback)>[
      ('Log food', () => context.push(AppRoutes.foodSearch)),
      ('+ Water', () => WellnessStore.instance.addWater(250)),
      ('Weigh in', () => context.go(AppRoutes.progress)),
      ('Track run', () => context.push(AppRoutes.tracking)),
      ('Timer', () => context.push(AppRoutes.timers)),
      ('Mobility', () => context.push(AppRoutes.mind)),
    ];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final c in chips)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: v.card,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: c.$2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        c.$1,
                        style: VeyroText.body(13.5, weight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final readiness = summary.readiness;
    final recovery = summary.recovery;
    if (readiness == null) {
      final status = summary.healthAccess;
      final canConnect = status == HealthAccessStatus.notGranted;
      final text = switch (status) {
        HealthAccessStatus.unavailable => 'Health data isn\'t available on this device, so readiness can\'t be calculated.',
        HealthAccessStatus.notGranted =>
          'Connect Health to see readiness, sleep, HRV and resting heart rate.',
        _ => 'No sleep, HRV or resting heart rate found yet. Wear your watch overnight and pull to refresh.',
      };
      return VCard(
        radius: 26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VLabel('Readiness'),
            const SizedBox(height: 6),
            Text(text, style: VeyroText.body(14, color: v.mute, height: 1.4)),
            if (canConnect) ...[
              const SizedBox(height: 12),
              VButton(
                'Connect Health',
                onPressed: () async {
                  final cubit = context.read<DashboardCubit>();
                  await getIt<RequestHealthAccess>()(const NoParams());
                  await cubit.load();
                },
              ),
            ],
          ],
        ),
      );
    }
    String hm(int? m) => m == null ? '—' : '${m ~/ 60}h ${m % 60}m';
    Widget stat(String value, String label) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: VeyroText.display(26)),
          Text(label, style: VeyroText.body(11, color: v.mute)),
        ],
      ),
    );
    final hrv = recovery?.latestHrv;
    final rhr = recovery?.latestRestingHr;
    return VCard(
      radius: 26,
      onTap: () => context.push(AppRoutes.recovery),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VRing(
                fraction: readiness.score / 100,
                color: readiness.score >= 60
                    ? VeyroColors.success
                    : readiness.score >= 40
                    ? const Color(0xFFE5A100)
                    : VeyroColors.danger,
                size: 84,
                child: Text('${readiness.score}', style: VeyroText.display(28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VLabel('Readiness'),
                    Text(
                      readiness.label.toUpperCase(),
                      style: VeyroText.display(32),
                    ),
                    Text(
                      readiness.summary,
                      style: VeyroText.body(12.5, color: v.mute),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: v.line)),
            ),
            child: Row(
              children: [
                stat(hm(recovery?.lastSleepMinutes), 'Sleep'),
                stat(hrv == null ? '—' : '${hrv.round()} ms', 'HRV'),
                stat(rhr == null ? '—' : '${rhr.round()}', 'Resting HR'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    return WellnessBuilder(
      builder: (context, store) {
        final total = store.kcalGoal + store.exerciseKcal;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 12,
                child: VCard(
                  onTap: () => context.go(AppRoutes.food),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VLabel('Calories'),
                      Text(
                        thousands(store.remainingKcal),
                        style: VeyroText.display(46),
                      ),
                      Text(
                        'kcal left today',
                        style: VeyroText.body(12, color: v.mute),
                      ),
                      const SizedBox(height: 6),
                      VProgressBar(value: store.eatenKcal / total, height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 10,
                child: VCard(
                  onTap: () => context.go(AppRoutes.food),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VLabel('Water'),
                      Text(
                        thousands(units.waterDisplay(store.waterMl)),
                        style: VeyroText.display(46),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            units.waterUnit,
                            style: VeyroText.body(12, color: v.mute),
                          ),
                          VButton(
                            '+ Add',
                            height: 30,
                            onPressed: () => store.addWater(250),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (store.waterMl / store.waterGoalMl).clamp(
                            0.0,
                            1.0,
                          ),
                          minHeight: 8,
                          backgroundColor: v.bg,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF2F6FE5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final coach = summary.coach;
    if (coach == null) return const SizedBox.shrink();
    final routine = coach.routine;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: v.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: v.acc, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VLabel('Coach'),
          const SizedBox(height: 8),
          Text(coach.text, style: VeyroText.body(14.5, height: 1.45)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              VButton(
                routine == null ? 'Start workout' : 'Start ${routine.name}',
                onPressed: () async {
                  final router = GoRouter.of(context);
                  if (routine == null) {
                    router.go(AppRoutes.workouts);
                    return;
                  }
                  final result = await getIt<StartWorkoutFromRoutine>()(
                    routine.id,
                  );
                  if (result.isSuccess) router.go(AppRoutes.activeWorkout);
                },
              ),
              if (summary.readiness != null)
                VButton(
                  'See recovery',
                  style: VButtonStyle.soft,
                  onPressed: () => context.push(AppRoutes.recovery),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HabitsCard extends StatelessWidget {
  const _HabitsCard();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => VCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const VLabel('Habits today'),
                InkWell(
                  onTap: () => context.push(AppRoutes.habits),
                  child: Text(
                    store.habits.isEmpty
                        ? 'Add ›'
                        : '${store.habitsDone} of ${store.habits.length} ›',
                    style: VeyroText.body(13, color: v.mute),
                  ),
                ),
              ],
            ),
            if (store.habits.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'No habits yet. Track supplements, stretching or sleep.',
                        style: VeyroText.body(13.5, color: v.mute),
                      ),
                    ),
                    VButton(
                      'Add',
                      style: VButtonStyle.soft,
                      height: 34,
                      onPressed: () => context.push(AppRoutes.habits),
                    ),
                  ],
                ),
              ),
            for (final h in store.habits.take(3))
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    HabitCheck(habit: h),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        h.name,
                        style: VeyroText.body(15, weight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${h.shownStreak} d',
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final r = summary.weeklyReport;
    if (r == null) return const SizedBox.shrink();
    final mins = r.minutesPerDay;
    final top = mins.fold(0, (a, b) => a > b ? a : b);
    final delta = r.activeMinutes - r.prevActiveMinutes;
    final subtitle = r.isEmpty
        ? 'No activity this week ›'
        : r.prevActiveMinutes == 0
        ? 'Your first full week of data ›'
        : delta == 0
        ? 'Same as last week ›'
        : '${delta > 0 ? 'Up' : 'Down'} ${delta.abs()} minutes on last week ›';
    return VCard(
      onTap: () => context.push(AppRoutes.report),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VLabel('Weekly report'),
                const SizedBox(height: 2),
                Text(
                  '${r.workouts} ${r.workouts == 1 ? 'WORKOUT' : 'WORKOUTS'} · ${r.activeMinutes} MIN',
                  style: VeyroText.display(28),
                ),
                Text(subtitle, style: VeyroText.body(12, color: v.mute)),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, m) in mins.indexed)
                  Container(
                    width: 7,
                    height: m <= 0 || top == 0 ? 3 : m / top * 34,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                      color: i == mins.length - 1 ? v.acc : v.ink,
                      borderRadius: BorderRadius.circular(2),
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
