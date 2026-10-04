import 'dart:async';

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/usecases/watch_tracked_activities.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_workout_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _blue = Color(0xFF2F6FE5);
const _violet = Color(0xFF8B5CF6);

enum _Kind {
  strength('Strength'),
  run('Run'),
  cycle('Cycle'),
  walk('Walk'),
  mobility('Mobility'),
  other('Other');

  const _Kind(this.label);

  final String label;

  /// Groups an imported workout (Apple Health / Health Connect names such as
  /// "Functional strength training" or "Core training") for the colour code.
  static _Kind fromTitle(String title) {
    final t = title.toLowerCase();
    const strengthWords = [
      'strength',
      'core',
      'weight',
      'resistance',
      'calisthenic',
      'hiit',
      'high intensity',
      'cross',
      'circuit',
      'bootcamp',
      'gymnastics',
      'kickboxing',
      'boxing',
      'martial',
    ];
    const mobilityWords = [
      'yoga',
      'pilates',
      'stretch',
      'flexib',
      'mind',
      'cooldown',
      'cool down',
      'tai chi',
      'barre',
      'breath',
    ];
    if (strengthWords.any(t.contains)) return _Kind.strength;
    if (mobilityWords.any(t.contains)) return _Kind.mobility;
    if (t.contains('run') || t.contains('jog')) return run;
    if (t.contains('walk') || t.contains('hik')) return walk;
    if (t.contains('cycl') || t.contains('bik')) return cycle;
    return other;
  }
}

class _Entry {
  const _Entry(this.kind, this.title, this.detail, this.at);

  final _Kind kind;
  final String title;
  final String detail;
  final DateTime at;
}

/// Training calendar built from logged workouts and recorded or imported
/// activities.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _today = DateTime.now();
  late DateTime _month = DateTime(_today.year, _today.month);
  late DateTime _selected = DateTime(_today.year, _today.month, _today.day);

  List<Workout> _workouts = const [];
  List<TrackedActivity> _activities = const [];
  final _subs = <StreamSubscription<Object?>>[];

  @override
  void initState() {
    super.initState();
    _subs
      ..add(
        getIt<WatchWorkoutHistory>()(const NoParams()).listen((w) {
          if (mounted) setState(() => _workouts = w);
        }),
      )
      ..add(
        getIt<WatchTrackedActivities>()(const NoParams()).listen((a) {
          if (mounted) setState(() => _activities = a);
        }),
      );
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  static int _key(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  Map<int, List<_Entry>> _entries(String Function(double) dist) {
    final out = <int, List<_Entry>>{};
    void add(DateTime at, _Entry e) => (out[_key(at.toLocal())] ??= []).add(e);
    for (final w in _workouts) {
      final mins = w.durationAt(DateTime.now()).inMinutes;
      final sets = w.completedSetCount;
      add(
        w.startedAt,
        _Entry(
          _Kind.strength,
          w.name,
          ['${mins}m', if (sets > 0) '$sets sets'].join(' · '),
          w.startedAt,
        ),
      );
    }
    for (final a in _activities) {
      final kind = switch (a.type) {
        TrackedActivityType.run => _Kind.run,
        TrackedActivityType.cycle => _Kind.cycle,
        TrackedActivityType.walk => _Kind.walk,
        TrackedActivityType.other => _Kind.fromTitle(a.displayName),
      };
      add(
        a.startedAt,
        _Entry(
          kind,
          a.displayName,
          [
            if (a.distanceMeters > 0) dist(a.distanceMeters / 1000),
            '${a.movingDuration.inMinutes}m',
            if (a.caloriesKcal > 0) '${a.caloriesKcal.round()} kcal',
          ].join(' · '),
          a.startedAt,
        ),
      );
    }
    for (final list in out.values) {
      list.sort((a, b) => a.at.compareTo(b.at));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final month = _month;
    final lead = DateTime(month.year, month.month, 1).weekday - 1;
    final days = DateTime(month.year, month.month + 1, 0).day;
    final all = _entries((km) => '${units.fd(km)} ${units.distanceUnit}');
    Color fill(_Kind k) => switch (k) {
      _Kind.strength => v.acc,
      _Kind.run => v.ink,
      _Kind.cycle => _blue,
      _Kind.walk => VeyroColors.success,
      _Kind.mobility => _violet,
      _Kind.other => v.mute,
    };
    Color on(_Kind k) => switch (k) {
      _Kind.strength => VeyroColors.onAccent,
      _Kind.run => v.bg,
      _ => Colors.white,
    };
    _Kind? main(List<_Entry>? list) => list == null
        ? null
        : (list.map((e) => e.kind).toList()
                ..sort((a, b) => a.index.compareTo(b.index)))
              .first;
    List<_Kind> kinds(List<_Entry>? list) => list == null
        ? const []
        : ({for (final e in list) e.kind}.toList()
            ..sort((a, b) => a.index.compareTo(b.index)));
    final activeDays = [
      for (var d = 1; d <= days; d++)
        if (all.containsKey(_key(DateTime(month.year, month.month, d)))) d,
    ].length;
    final sel = _selected;
    final selEntries = all[_key(sel)] ?? const <_Entry>[];
    final thisMonth = month.year == _today.year && month.month == _today.month;
    final todayKey = _key(DateTime(_today.year, _today.month, _today.day));
    return VSubPage(
      title: 'Calendar',
      maxWidth: 720,
      children: [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Nav(
                    icon: Icons.chevron_left,
                    onTap: () => setState(() {
                      _month = DateTime(month.year, month.month - 1);
                      _selected = _month;
                    }),
                  ),
                  Column(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(month).toUpperCase(),
                        style: VeyroText.display(26),
                      ),
                      Text(
                        '$activeDays active ${activeDays == 1 ? 'day' : 'days'}',
                        style: VeyroText.body(12, color: v.mute),
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: thisMonth ? 0.3 : 1,
                    child: _Nav(
                      icon: Icons.chevron_right,
                      onTap: () {
                        if (thisMonth) return;
                        setState(() {
                          _month = DateTime(month.year, month.month + 1);
                          final isNow =
                              _month.year == _today.year &&
                              _month.month == _today.month;
                          _selected = isNow
                              ? DateTime(_today.year, _today.month, _today.day)
                              : _month;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                    Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: VeyroText.body(
                            11,
                            weight: FontWeight.w600,
                            color: v.mute,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  for (var i = 0; i < lead; i++) const SizedBox.shrink(),
                  for (var d = 1; d <= days; d++)
                    Builder(
                      builder: (context) {
                        final date = DateTime(month.year, month.month, d);
                        final k = main(all[_key(date)]);
                        final isToday = _key(date) == todayKey;
                        return GestureDetector(
                          onTap: () => setState(() => _selected = date),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: k != null ? fill(k) : Colors.transparent,
                              border: Border.all(
                                color: _key(date) == _key(sel)
                                    ? v.acc
                                    : isToday
                                    ? v.ink
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '$d',
                                  style: VeyroText.body(
                                    13,
                                    weight: FontWeight.w700,
                                    color: k != null ? on(k) : v.ink,
                                  ),
                                ),
                                // One dot per extra workout type that day.
                                Positioned(
                                  bottom: 3,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final x in kinds(
                                        all[_key(date)],
                                      ).skip(1))
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: fill(x),
                                            border: Border.all(
                                              color: v.card,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  for (final k in _Kind.values)
                    Text(
                      '● ${k.label}',
                      style: VeyroText.body(11.5, color: fill(k)),
                    ),
                ],
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VLabel(DateFormat('MMM d').format(sel)),
              if (selEntries.isEmpty) ...[
                Text(
                  (sel.isAfter(_today) ? 'Nothing yet' : 'Rest day')
                      .toUpperCase(),
                  style: VeyroText.display(26, height: 1.1),
                ),
                Text(
                  sel.isAfter(_today) ? 'Upcoming' : 'Nothing logged',
                  style: VeyroText.body(13, color: v.mute),
                ),
              ] else
                for (final e in selEntries) ...[
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: fill(e.kind),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.title.toUpperCase(),
                          style: VeyroText.display(26, height: 1.1),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 18),
                    child: Text(
                      '${DateFormat.jm().format(e.at.toLocal())} · ${e.detail}',
                      style: VeyroText.body(13, color: v.mute),
                    ),
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36,
    height: 36,
    child: IconButton.filled(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: context.veyro.bg,
        foregroundColor: context.veyro.ink,
      ),
      onPressed: onTap,
      icon: Icon(icon),
    ),
  );
}
