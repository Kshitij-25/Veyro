import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/health_sync/presentation/cubit/health_sync_cubit.dart';
import 'package:fitness_trakcer/features/sleep/domain/entities/sleep_night.dart';
import 'package:fitness_trakcer/features/sleep/presentation/cubit/sleep_cubit.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _awake = Color(0xFFE5A100);
const _rem = Color(0xFFFF5A2B);
const _light = Color(0xFF7B8794);
const _deep = Color(0xFF2F6FE5);

Color _stageColor(SleepStage s) => switch (s) {
  SleepStage.awake => _awake,
  SleepStage.rem => _rem,
  SleepStage.light || SleepStage.asleep => _light,
  SleepStage.deep => _deep,
};

String _dur(int minutes) => minutes >= 60
    ? '${minutes ~/ 60}h ${(minutes % 60).toString().padLeft(2, '0')}m'
    : '${minutes}m';

String _clock(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  return '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'am' : 'pm'}';
}

const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
const _weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Sleep read from Apple Health / Health Connect: the latest night with its
/// stages, plus the last seven nights.
class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  /// Index into the nights list; null follows the latest night.
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthSyncCubit, HealthSyncState>(
      listenWhen: (a, b) => a.lastSync != b.lastSync,
      listener: (context, _) => context.read<SleepCubit>().load(),
      child: WellnessBuilder(
        builder: (context, store) => VSubPage(
          title: 'Sleep',
          maxWidth: 720,
          children: [
            BlocBuilder<SleepCubit, SleepState>(
              builder: (context, state) {
                if (state.status == ViewStatus.loading ||
                    state.status == ViewStatus.initial) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.nights.isEmpty && state.history.isEmpty) {
                  return const _EmptyState();
                }
                final index = (_selected ?? state.nights.length - 1).clamp(
                  0,
                  state.nights.isEmpty ? 0 : state.nights.length - 1,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.nights.isNotEmpty)
                      _Content(
                        nights: state.nights,
                        index: index,
                        goalHours: store.sleepGoalHours,
                        onSelect: (i) => setState(() => _selected = i),
                        onGoal: store.setSleepGoal,
                      ),
                    if (state.history.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _HistoryCard(
                        history: state.history,
                        goalMinutes: (store.sleepGoalHours * 60).round(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Imported sleep history: averages and bars grouped by week, month or year.
class _HistoryCard extends StatefulWidget {
  const _HistoryCard({required this.history, required this.goalMinutes});

  final List<SleepDay> history;
  final int goalMinutes;

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  String _range = '90D';

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final now = DateTime.now();
    final days = switch (_range) {
      '30D' => 30,
      '90D' => 90,
      '1Y' => 365,
      _ => null,
    };
    final since = days == null ? null : now.subtract(Duration(days: days));
    final nights = [
      for (final d in widget.history)
        if (since == null || d.date.isAfter(since)) d,
    ];

    // Group: weeks for up to 90 days, months for a year, years for everything.
    final groups = <String, List<int>>{};
    final labels = <String, String>{};
    for (final d in nights) {
      final String key;
      final String label;
      if (_range == 'All') {
        key = '${d.date.year}';
        label = "'${(d.date.year % 100).toString().padLeft(2, '0')}";
      } else if (_range == '1Y') {
        key = '${d.date.year}-${d.date.month.toString().padLeft(2, '0')}';
        label = _months[d.date.month - 1].substring(0, 1);
      } else {
        final monday = DateTime(
          d.date.year,
          d.date.month,
          d.date.day - (d.date.weekday - 1),
        );
        key =
            '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
        label = '${monday.day}';
      }
      groups.putIfAbsent(key, () => []).add(d.asleepMinutes);
      labels[key] = label;
    }
    final keys = groups.keys.toList()..sort();
    final averages = [
      for (final k in keys)
        groups[k]!.reduce((a, b) => a + b) / groups[k]!.length / 60,
    ];
    final minutes = nights.map((n) => n.asleepMinutes).toList();
    final avg = minutes.isEmpty
        ? 0.0
        : minutes.reduce((a, b) => a + b) / minutes.length;
    final hitGoal = minutes.where((m) => m >= widget.goalMinutes).length;

    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('HISTORY', style: VeyroText.label(color: v.mute)),
          const SizedBox(height: 8),
          VTabs<String>(
            options: const {
              '30D': '30D',
              '90D': '90D',
              '1Y': '1Y',
              'All': 'All',
            },
            selected: _range,
            onChanged: (r) => setState(() => _range = r),
          ),
          const SizedBox(height: 12),
          if (nights.isEmpty)
            Text(
              'No sleep recorded in this period.',
              style: VeyroText.body(13, color: v.mute),
            )
          else ...[
            Row(
              children: [
                for (final (value, label) in [
                  (_dur(avg.round()), 'average'),
                  ('${nights.length}', 'nights'),
                  ('${(hitGoal / nights.length * 100).round()}%', 'hit goal'),
                ])
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value, style: VeyroText.display(24)),
                        Text(label, style: VeyroText.body(11.5, color: v.mute)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: SizedBox(
                  width: (keys.length * 30.0).clamp(
                    MediaQuery.sizeOf(context).width - 80,
                    double.infinity,
                  ),
                  child: VBarChart(
                    values: averages,
                    labels: [for (final k in keys) labels[k]!],
                    captions: [for (final a in averages) a.toStringAsFixed(1)],
                    colors: [
                      for (final a in averages)
                        a * 60 >= widget.goalMinutes ? v.acc : v.mute,
                    ],
                    maxValue: 10,
                    height: 150,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _range == 'All'
                  ? 'Average hours per night, by year.'
                  : _range == '1Y'
                  ? 'Average hours per night, by month.'
                  : 'Average hours per night, by week (starting Monday).',
              style: VeyroText.body(11.5, color: v.mute),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final sync = context.watch<HealthSyncCubit>();
    final status = sync.state.access;
    final text = status == HealthAccessStatus.unavailable
        ? 'Health data isn\'t available on this device, so sleep can\'t be shown.'
        : !sync.state.isConnected
        ? 'Connect Health to see your sleep, stages and trends.'
        : 'No sleep recorded in the last 7 nights. Wear your watch to bed, or turn on sleep tracking in your health app.';
    return VCard(
      radius: 26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VLabel('Sleep'),
          const SizedBox(height: 6),
          Text(text, style: VeyroText.body(14, color: v.mute, height: 1.4)),
          if (status != HealthAccessStatus.unavailable) ...[
            const SizedBox(height: 12),
            VButton(
              sync.state.isConnected ? 'Sync now' : 'Connect Health',
              onPressed: () async {
                final sleep = context.read<SleepCubit>();
                if (sync.state.isConnected) {
                  await sync.sync(days: 14);
                } else {
                  await sync.connect();
                }
                await sleep.load();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.nights,
    required this.index,
    required this.goalHours,
    required this.onSelect,
    required this.onGoal,
  });

  final List<SleepNight> nights;
  final int index;
  final double goalHours;
  final ValueChanged<int> onSelect;
  final ValueChanged<double> onGoal;

  String _label(SleepNight n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = today.difference(n.date).inDays;
    if (days == 0) return 'Last night';
    return '${_weekdayNames[n.date.weekday - 1]}, ${_months[n.date.month - 1]} ${n.date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final night = nights[index];
    final goalMin = (goalHours * 60).round();
    final score = night.score(goalMin);

    // Average bedtime, measured from 6 pm so nights either side of midnight
    // average sensibly.
    final avgBed =
        nights
            .map(
              (n) =>
                  (n.bedtime.hour * 60 + n.bedtime.minute - 18 * 60 + 1440) %
                  1440,
            )
            .reduce((a, b) => a + b) /
        nights.length;
    final bedMinutes = ((avgBed + 18 * 60) % 1440).round();
    final avgBedText = _clock(
      DateTime(2000, 1, 1, bedMinutes ~/ 60, bedMinutes % 60),
    );
    final debt = nights.fold<int>(
      0,
      (sum, n) => sum + (goalMin - n.asleepMinutes).clamp(0, 1 << 20),
    );

    final stageTiles = night.hasStages
        ? [
            ('Awake', night.awakeMinutes, SleepStage.awake),
            ('REM', night.remMinutes, SleepStage.rem),
            ('Light', night.lightMinutes, SleepStage.light),
            ('Deep', night.deepMinutes, SleepStage.deep),
          ]
        : [('Asleep', night.asleepMinutes, SleepStage.asleep)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VCard(
          color: v.ink,
          radius: 26,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              VRing(
                fraction: score / 100,
                color: v.acc,
                size: 104,
                child: Text(
                  '$score',
                  style: VeyroText.display(28, color: v.bg),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dur(night.asleepMinutes),
                      style: VeyroText.display(44, color: v.bg),
                    ),
                    Text(
                      '${_clock(night.bedtime)} to ${_clock(night.wakeTime)}',
                      style: VeyroText.body(
                        13,
                        color: v.bg.withValues(alpha: .7),
                      ),
                    ),
                    Text(
                      'Sleep score $score · ${_label(night)}',
                      style: VeyroText.body(
                        12,
                        color: v.bg.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VLabel(_label(night)),
              const SizedBox(height: 10),
              SizedBox(height: 100, child: _Timeline(night: night)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _clock(night.bedtime),
                    style: VeyroText.body(11, color: v.mute),
                  ),
                  Text(
                    _clock(night.wakeTime),
                    style: VeyroText.body(11, color: v.mute),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final s in stageTiles)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _stageColor(s.$3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                s.$1,
                                style: VeyroText.body(11.5, color: v.mute),
                              ),
                            ],
                          ),
                          Text(_dur(s.$2), style: VeyroText.display(20)),
                        ],
                      ),
                    ),
                ],
              ),
              if (!night.hasStages) ...[
                const SizedBox(height: 8),
                Text(
                  'Your device doesn\'t report sleep stages.',
                  style: VeyroText.body(12, color: v.mute),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VLabel('Last ${nights.length} nights (h) · tap to view'),
              const SizedBox(height: 8),
              _NightBars(
                nights: nights,
                selected: index,
                goalMinutes: goalMin,
                onSelect: onSelect,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        VGrid2(
          children: [
            VStatTile(
              label: 'Efficiency',
              value: '${(night.efficiency * 100).round()}%',
            ),
            VStatTile(label: 'Avg bedtime', value: avgBedText),
            VStatTile(
              label: 'Sleep debt',
              value: debt == 0 ? 'None' : _dur(debt),
            ),
            VStatTile(
              label: 'Sleeping HR',
              value: night.sleepingHr == null
                  ? '—'
                  : '${night.sleepingHr!.round()} bpm',
            ),
          ],
        ),
        const SizedBox(height: 12),
        VCard(
          child: VStepper(
            label: 'Sleep goal (h)',
            value: goalHours.toStringAsFixed(1),
            onMinus: () => onGoal(goalHours - .5),
            onPlus: () => onGoal(goalHours + .5),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Efficiency is time asleep between bedtime and waking. The score weighs duration against your goal, efficiency and, when available, deep and REM share. Sleep debt is the shortfall against your goal over these nights.',
          style: VeyroText.body(11.5, color: v.mute, height: 1.4),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.night});

  final SleepNight night;

  @override
  Widget build(BuildContext context) {
    const rows = {
      SleepStage.awake: 4.0,
      SleepStage.rem: 30.0,
      SleepStage.light: 56.0,
      SleepStage.asleep: 56.0,
      SleepStage.deep: 82.0,
    };
    final span = night.spanMinutes <= 0 ? 1 : night.spanMinutes;
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          for (final s in night.segments)
            Positioned(
              left:
                  s.start.difference(night.bedtime).inMinutes /
                  span *
                  c.maxWidth,
              width: (s.minutes / span * c.maxWidth - 1).clamp(2.0, c.maxWidth),
              top: rows[s.stage],
              height: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _stageColor(s.stage),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NightBars extends StatelessWidget {
  const _NightBars({
    required this.nights,
    required this.selected,
    required this.goalMinutes,
    required this.onSelect,
  });

  final List<SleepNight> nights;
  final int selected;
  final int goalMinutes;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    const maxHours = 10.0;
    return SizedBox(
      height: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < nights.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelect(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (nights[i].asleepMinutes / 60).toStringAsFixed(1),
                      style: VeyroText.body(
                        11,
                        color: i == selected ? v.ink : v.mute,
                        weight: i == selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: (nights[i].asleepMinutes / 60 / maxHours * 110)
                          .clamp(4.0, 110.0),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: nights[i].asleepMinutes >= goalMinutes
                            ? v.acc
                            : v.mute.withValues(alpha: .6),
                        borderRadius: BorderRadius.circular(8),
                        border: i == selected
                            ? Border.all(color: v.ink, width: 2)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _weekdays[nights[i].date.weekday - 1],
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
