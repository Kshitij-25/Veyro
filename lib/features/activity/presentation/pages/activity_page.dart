import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Root of the Activity tab: today's steps/distance/calories and the week.
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  static const _stepGoal = 10000;
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<ActivityCubit, ActivityState>(
          listenWhen: (previous, current) =>
              current.failure != null && current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
          builder: (context, state) {
            final today = state.today;
            if (today == null) return const LoadingView();
            final week = state.week;
            final maxSteps = week.fold<int>(
              _stepGoal,
              (m, d) => d.steps > m ? d.steps : m,
            );
            final distance = UnitConverter.distanceToDisplay(
              today.distanceMeters,
              units,
            );
            return ContentConstraint(
              maxWidth: 1100,
              child: RefreshIndicator.adaptive(
                onRefresh: context.read<ActivityCubit>().sync,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  children: [
                    VTitle(
                      'Activity',
                      trailing: Row(
                        children: [
                          VButton(
                            'History',
                            style: VButtonStyle.card,
                            onPressed: () =>
                                context.push(AppRoutes.trackingHistory),
                          ),
                          const SizedBox(width: 8),
                          VButton(
                            '● Track',
                            onPressed: () => context.push(AppRoutes.tracking),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    VTwoColumn(
                      left: [
                        VCard(
                          color: v.ink,
                          radius: 26,
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VLabel(
                                'Today',
                                color: v.bg.withValues(alpha: .6),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: NumberFormat.decimalPattern().format(
                                    today.steps,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' steps',
                                      style: VeyroText.display(
                                        22,
                                        color: v.bg.withValues(alpha: .6),
                                      ),
                                    ),
                                  ],
                                ),
                                style: VeyroText.display(
                                  76,
                                  color: v.bg,
                                  height: .9,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _HeroStat(
                                    distance.toStringAsFixed(1),
                                    units.distanceUnit,
                                  ),
                                  const SizedBox(width: 26),
                                  _HeroStat(
                                    '${today.activeCaloriesKcal.round()}',
                                    'active kcal',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _HealthAccessTile(state: state, units: units),
                      ],
                      right: [
                        VCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const VLabel('Last 7 days'),
                                  Text(
                                    'goal ${NumberFormat.decimalPattern().format(_stepGoal)}',
                                    style: VeyroText.body(12, color: v.mute),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 140,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: v.line),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      for (final d in week)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  d.steps >= 1000
                                                      ? '${(d.steps / 1000).toStringAsFixed(1)}k'
                                                      : '${d.steps}',
                                                  style: VeyroText.body(
                                                    10.5,
                                                    weight: FontWeight.w700,
                                                    color: v.mute,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  height:
                                                      100 * d.steps / maxSteps,
                                                  decoration: BoxDecoration(
                                                    color: d.steps >= _stepGoal
                                                        ? v.acc
                                                        : v.mute.withValues(
                                                            alpha: .35,
                                                          ),
                                                    borderRadius:
                                                        const BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            8,
                                                          ),
                                                          bottom:
                                                              Radius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  for (final d in week)
                                    Expanded(
                                      child: Text(
                                        _weekdays[d.date.weekday - 1],
                                        textAlign: TextAlign.center,
                                        style: VeyroText.body(
                                          12,
                                          weight: FontWeight.w700,
                                          color: v.mute,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const _WeeklyGoal(),
                        const _PersonalBests(),
                        const _Gear(),
                        VCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              for (final (i, day)
                                  in state.week.reversed.indexed)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: i == 0
                                        ? null
                                        : Border(
                                            top: BorderSide(color: v.line),
                                          ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('EEE, MMM d')
                                            .format(day.date),
                                        style: VeyroText.body(14),
                                      ),
                                      Text(
                                        NumberFormat.decimalPattern().format(
                                          day.steps,
                                        ),
                                        style: VeyroText.display(20),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat(this.value, this.caption);

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: VeyroText.display(30, color: v.bg)),
        Text(
          caption,
          style: VeyroText.body(11, color: v.bg.withValues(alpha: .6)),
        ),
      ],
    );
  }
}

class _HealthAccessTile extends StatelessWidget {
  const _HealthAccessTile({required this.state, required this.units});

  final ActivityState state;
  final UnitSystem units;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityCubit>();
    // iOS never says whether read access was granted, so also trust the
    // app-wide Health sync, which remembers a successful connection.
    final connected = context.watch<HealthSyncCubit>().state.isConnected;
    final access =
        connected && state.healthAccess != HealthAccessStatus.unavailable
        ? HealthAccessStatus.granted
        : state.healthAccess;
    final (title, subtitle, dot, onTap) = switch (access) {
      HealthAccessStatus.unavailable => (
        'Health data unavailable here',
        'Log today\'s activity manually.',
        context.veyro.mute,
        () => _logManually(context),
      ),
      HealthAccessStatus.granted => (
        'Synced with Health',
        'Last 7 days',
        VeyroColors.success,
        state.isSyncing ? null : cubit.sync,
      ),
      _ => (
        'Connect Health',
        'Import steps, distance and calories.',
        context.veyro.acc,
        cubit.connectHealth,
      ),
    };
    final v = context.veyro;
    return VCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: VeyroText.body(14, weight: FontWeight.w700)),
                Text(subtitle, style: VeyroText.body(12, color: v.mute)),
              ],
            ),
          ),
          if (state.isSyncing)
            const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator.adaptive(),
            )
          else
            Icon(Icons.sync, size: 20, color: v.mute),
        ],
      ),
    );
  }

  Future<void> _logManually(BuildContext context) async {
    final cubit = context.read<ActivityCubit>();
    final steps = TextEditingController();
    final distance = TextEditingController();
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Log activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: steps,
              decoration: const InputDecoration(labelText: 'Steps'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: distance,
              decoration: InputDecoration(
                labelText: 'Distance (${units.distanceUnit})',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final distanceValue = tryParseDecimal(distance.text) ?? 0;
    await cubit.logManual(
      steps: int.tryParse(steps.text) ?? 0,
      distanceMeters: UnitConverter.distanceFromDisplay(distanceValue, units),
    );
  }
}

class _WeeklyGoal extends StatelessWidget {
  const _WeeklyGoal();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Weekly distance goal'),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: units.fd(29.6),
              children: [
                TextSpan(
                  text: ' of ${units.fd(40, 0)} ${units.distanceUnit}',
                  style: VeyroText.body(16, color: v.mute),
                ),
              ],
            ),
            style: VeyroText.display(40),
          ),
          const SizedBox(height: 8),
          const VProgressBar(value: .74, height: 8),
        ],
      ),
    );
  }
}

class _PersonalBests extends StatelessWidget {
  const _PersonalBests();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final rows = [
      ('Fastest 5K', '24:12'),
      (
        'Fastest ${units == UnitSystem.imperial ? 'mile' : 'km'}',
        units == UnitSystem.imperial ? '6:52' : '4:16',
      ),
      ('Longest run', '${units.fd(16.1)} ${units.distanceUnit}'),
    ];
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Personal bests'),
          for (final r in rows)
            Container(
              height: 42,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: v.line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.$1, style: VeyroText.body(14)),
                  Text(r.$2, style: VeyroText.display(22)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Gear extends StatelessWidget {
  const _Gear();

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Gear'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nike Pegasus 40',
                  style: VeyroText.body(15, weight: FontWeight.w700),
                ),
                Text(
                  '${units.fd(312.4, 0)} of ${units.fd(800, 0)} ${units.distanceUnit}',
                  style: VeyroText.body(13, color: context.veyro.mute),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: .39,
              minHeight: 8,
              valueColor: AlwaysStoppedAnimation(VeyroColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
