import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_pickers.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

class FastingPage extends StatelessWidget {
  const FastingPage({super.key});

  static const _stages = [
    ('Fed state', '0–4 h', 0),
    ('Early fasting', '4–8 h', 4),
    ('Fat burning', '8–12 h', 8),
    ('Deep fasting', '12–16 h', 12),
    ('Autophagy', '16 h+', 16),
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
        builder: (context, _) {
          final elapsed = store.fastOn
              ? DateTime.now().difference(store.fastStart).inSeconds
              : 0;
          final goal = store.fastHours * 3600;
          final hours = elapsed / 3600;
          return VSubPage(
            title: 'Fasting',
            maxWidth: 560,
            children: [
              VCard(
                child: Center(
                  child: VRing(
                    fraction: store.fastOn ? elapsed / goal : 0,
                    color: v.acc,
                    size: 210,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(clockText(elapsed), style: VeyroText.display(54)),
                        Text(
                          !store.fastOn
                              ? 'Not fasting'
                              : elapsed >= goal
                              ? 'Goal reached'
                              : '${Duration(seconds: goal - elapsed).clock} to go',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                        Text(
                          '${store.fastHours}:${24 - store.fastHours}',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (store.fastOn)
                GestureDetector(
                  onTap: () => _editStart(context, store),
                  child: Center(
                    child: Text(
                      'Started ${_when(store.fastStart)} · tap to change',
                      style: VeyroText.body(13, color: v.mute),
                    ),
                  ),
                ),
              VButton(
                store.fastOn ? 'End fast' : 'Start fast',
                height: 52,
                radius: 16,
                expand: true,
                onPressed: () => _toggle(context, store, elapsed >= goal),
              ),
              VChipRow<int>(
                options: {
                  for (final h in [12, 14, 16, 18, 20]) h: '$h:${24 - h}',
                },
                selected: store.fastHours,
                onChanged: store.setFastHours,
              ),
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VLabel('Stages'),
                    const SizedBox(height: 6),
                    for (final s in _stages)
                      Builder(
                        builder: (context) {
                          final on = store.fastOn && hours >= s.$3;
                          return Container(
                            height: 44,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: v.line)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: on ? v.acc : v.bg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    on ? '✓' : '',
                                    style: VeyroText.body(
                                      13,
                                      weight: FontWeight.w800,
                                      color: VeyroColors.onAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    s.$1,
                                    style: VeyroText.body(
                                      15,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  s.$2,
                                  style: VeyroText.body(12.5, color: v.mute),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (store.fastHistory.isNotEmpty) ...[
                _StatsCard(history: store.fastHistory),
                VCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const VLabel('History'),
                      for (final r in store.fastHistory.take(10))
                        Container(
                          height: 48,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: v.line)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                r.reachedGoal
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 20,
                                color: r.reachedGoal ? v.acc : v.mute,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _hm(r.duration),
                                      style: VeyroText.body(
                                        15,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '${_when(r.start)} · goal ${r.goalHours}h',
                                      style: VeyroText.body(12, color: v.mute),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: v.mute,
                                ),
                                onPressed: () => store.deleteFast(r),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  static const _months = [
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

  static String _hm(Duration d) =>
      '${d.inHours}h ${(d.inMinutes % 60).toString().padLeft(2, '0')}m';

  static String _when(DateTime t) {
    final now = DateTime.now();
    final day = DateTime(t.year, t.month, t.day);
    final today = DateTime(now.year, now.month, now.day);
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final time =
        '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'am' : 'pm'}';
    final diff = today.difference(day).inDays;
    final label = diff == 0
        ? 'Today'
        : diff == 1
        ? 'Yesterday'
        : '${_months[t.month - 1]} ${t.day}';
    return '$label, $time';
  }

  Future<void> _toggle(
    BuildContext context,
    WellnessStore store,
    bool reachedGoal,
  ) async {
    if (!store.fastOn) return store.startFast();
    if (!reachedGoal) {
      final ok = await showVeyroConfirm(
        context,
        title: 'End fast early?',
        message:
            'You haven\'t reached your ${store.fastHours} hour goal yet. The fast is still saved in your history.',
        confirmLabel: 'End fast',
        cancelLabel: 'Keep going',
      );
      if (!ok) return;
    }
    store.endFast();
  }

  Future<void> _editStart(BuildContext context, WellnessStore store) async {
    final picked = await showAdaptiveTimePicker(
      context,
      initial: TimeOfDay.fromDateTime(store.fastStart),
    );
    if (picked == null) return;
    final now = DateTime.now();
    var start = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );
    // A time later than now can only mean yesterday.
    if (start.isAfter(now)) start = start.subtract(const Duration(days: 1));
    store.setFastStart(start);
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.history});

  final List<FastRecord> history;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final since = DateTime.now().subtract(const Duration(days: 7));
    final recent = history.where((r) => r.end.isAfter(since)).toList();
    final avg = recent.isEmpty
        ? Duration.zero
        : Duration(
            minutes:
                recent.fold<int>(0, (a, r) => a + r.duration.inMinutes) ~/
                recent.length,
          );
    final hit = recent.where((r) => r.reachedGoal).length;
    Widget stat(String value, String label) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: VeyroText.display(26)),
          Text(label, style: VeyroText.body(11.5, color: v.mute)),
        ],
      ),
    );
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Last 7 days'),
          const SizedBox(height: 8),
          Row(
            children: [
              stat('${recent.length}', 'fasts'),
              stat(recent.isEmpty ? '—' : FastingPage._hm(avg), 'average'),
              stat('$hit', 'goals reached'),
            ],
          ),
        ],
      ),
    );
  }
}
