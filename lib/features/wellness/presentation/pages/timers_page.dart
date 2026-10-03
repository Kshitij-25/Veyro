import 'dart:async';

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';

/// Interval, stopwatch and countdown timers.
class TimersPage extends StatefulWidget {
  const TimersPage({super.key});

  @override
  State<TimersPage> createState() => _TimersPageState();
}

class _TimersPageState extends State<TimersPage> {
  String _mode = 'Interval';

  // interval
  int _work = 40;
  int _rest = 20;
  int _rounds = 8;
  bool _started = false;
  bool _running = false;
  String _phase = 'work';
  int _t = 0;
  int _round = 1;

  // stopwatch
  int _sw = 0;
  bool _swRun = false;
  final List<int> _laps = [];

  // countdown
  int _cd = 300;
  int _cdLeft = 300;
  bool _cdRun = false;

  late final Timer _ticker = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _tick(),
  );

  @override
  void initState() {
    super.initState();
    _ticker;
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      if (_mode == 'Interval' && _running) {
        var t = _t + 1;
        var phase = _phase;
        var round = _round;
        if (phase == 'work' && t >= _work) {
          if (_rest > 0) {
            phase = 'rest';
          } else {
            round++;
          }
          t = 0;
        } else if (phase == 'rest' && t >= _rest) {
          round++;
          phase = 'work';
          t = 0;
        }
        if (round > _rounds) {
          _running = false;
          _phase = 'done';
          _t = 0;
          _round = _rounds;
        } else {
          _t = t;
          _phase = phase;
          _round = round;
        }
      }
      if (_swRun) _sw++;
      if (_cdRun) {
        _cdLeft = (_cdLeft - 1).clamp(0, 1 << 30);
        if (_cdLeft == 0) _cdRun = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return VSubPage(
      title: 'Timers',
      maxWidth: 560,
      children: [
        VTabs<String>(
          options: const {
            'Interval': 'Interval',
            'Stopwatch': 'Stopwatch',
            'Countdown': 'Countdown',
          },
          selected: _mode,
          onChanged: (m) => setState(() => _mode = m),
        ),
        if (_mode == 'Interval') ..._interval(v),
        if (_mode == 'Stopwatch') ..._stopwatch(v),
        if (_mode == 'Countdown') ..._countdown(v),
      ],
    );
  }

  List<Widget> _interval(VeyroColors v) {
    if (!_started) {
      return [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VChipRow<String>(
                options: const {
                  'Tabata': 'Tabata',
                  'HIIT': 'HIIT',
                  'EMOM': 'EMOM',
                  'Boxing': 'Boxing',
                },
                selected: null,
                onCard: true,
                onChanged: (p) => setState(() {
                  final preset = {
                    'Tabata': [20, 10, 8],
                    'HIIT': [40, 20, 10],
                    'EMOM': [60, 0, 12],
                    'Boxing': [180, 60, 6],
                  }[p]!;
                  _work = preset[0];
                  _rest = preset[1];
                  _rounds = preset[2];
                }),
              ),
              const SizedBox(height: 14),
              VStepper(
                label: 'Work',
                value: '$_work s',
                onMinus: () =>
                    setState(() => _work = (_work - 5).clamp(5, 3600)),
                onPlus: () => setState(() => _work += 5),
              ),
              const SizedBox(height: 14),
              VStepper(
                label: 'Rest',
                value: '$_rest s',
                onMinus: () =>
                    setState(() => _rest = (_rest - 5).clamp(0, 3600)),
                onPlus: () => setState(() => _rest += 5),
              ),
              const SizedBox(height: 14),
              VStepper(
                label: 'Rounds',
                value: '$_rounds',
                onMinus: () =>
                    setState(() => _rounds = (_rounds - 1).clamp(1, 99)),
                onPlus: () => setState(() => _rounds++),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Total ${clockText(_rounds * (_work + _rest))}',
                  style: VeyroText.body(13, color: v.mute),
                ),
              ),
            ],
          ),
        ),
        VButton(
          'Start',
          height: 52,
          radius: 16,
          expand: true,
          onPressed: () => setState(() {
            _started = true;
            _running = true;
            _phase = 'work';
            _t = 0;
            _round = 1;
          }),
        ),
      ];
    }
    final len = _phase == 'work' ? _work : _rest;
    final left = (len - _t).clamp(0, len);
    final done = _phase == 'done';
    final color = _phase == 'rest'
        ? VeyroColors.success
        : done
        ? v.mute
        : VeyroColors.accent;
    final remaining = done
        ? 0
        : (_rounds - _round) * (_work + _rest) +
              left +
              (_phase == 'work' ? _rest : 0);
    return [
      VCard(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Text(
              (done
                      ? 'Done'
                      : _phase == 'work'
                      ? 'Work'
                      : 'Rest')
                  .toUpperCase(),
              style: VeyroText.display(
                22,
                color: color,
              ).copyWith(letterSpacing: 3),
            ),
            Text(
              done ? '0:00' : clockText(left),
              style: VeyroText.display(120, height: .95),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: done ? 0 : left / len,
                minHeight: 8,
                backgroundColor: v.bg,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Round $_round of $_rounds · ${clockText(remaining)} left',
              style: VeyroText.body(14, color: v.mute),
            ),
          ],
        ),
      ),
      Row(
        children: [
          VButton(
            'Stop',
            style: VButtonStyle.card,
            height: 56,
            radius: 16,
            onPressed: () => setState(() {
              _started = false;
              _running = false;
              _phase = 'work';
              _t = 0;
              _round = 1;
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _Big(
              done
                  ? 'Restart'
                  : _running
                  ? 'Pause'
                  : 'Resume',
              onPressed: () => setState(() {
                if (done) {
                  _running = true;
                  _phase = 'work';
                  _t = 0;
                  _round = 1;
                } else {
                  _running = !_running;
                }
              }),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _stopwatch(VeyroColors v) => [
    VCard(
      padding: const EdgeInsets.all(28),
      child: Center(child: Text(clockText(_sw), style: VeyroText.display(100))),
    ),
    Row(
      children: [
        VButton(
          'Lap',
          style: VButtonStyle.card,
          height: 56,
          radius: 16,
          onPressed: _swRun ? () => setState(() => _laps.add(_sw)) : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Big(
            _swRun ? 'Stop' : 'Start',
            onPressed: () => setState(() => _swRun = !_swRun),
          ),
        ),
        const SizedBox(width: 8),
        VButton(
          'Reset',
          style: VButtonStyle.card,
          height: 56,
          radius: 16,
          onPressed: () => setState(() {
            _sw = 0;
            _laps.clear();
            _swRun = false;
          }),
        ),
      ],
    ),
    for (final (i, l) in _laps.indexed.toList().reversed)
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: v.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Lap ${i + 1}', style: VeyroText.body(14, color: v.mute)),
            Text(
              clockText(l - (i == 0 ? 0 : _laps[i - 1])),
              style: VeyroText.display(20),
            ),
            Text(clockText(l), style: VeyroText.body(14, color: v.mute)),
          ],
        ),
      ),
  ];

  List<Widget> _countdown(VeyroColors v) => [
    VChipRow<int>(
      options: {
        for (final m in [1, 3, 5, 10, 15]) m * 60: '$m min',
      },
      selected: _cd,
      onChanged: (s) => setState(() {
        _cd = s;
        _cdLeft = s;
        _cdRun = false;
      }),
    ),
    VCard(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Text(clockText(_cdLeft), style: VeyroText.display(100)),
      ),
    ),
    Row(
      children: [
        VButton(
          'Reset',
          style: VButtonStyle.card,
          height: 56,
          radius: 16,
          onPressed: () => setState(() {
            _cdLeft = _cd;
            _cdRun = false;
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Big(
            _cdRun ? 'Pause' : 'Start',
            onPressed: () => setState(() {
              if (_cdLeft == 0) {
                _cdLeft = _cd;
                _cdRun = true;
              } else {
                _cdRun = !_cdRun;
              }
            }),
          ),
        ),
      ],
    ),
  ];
}

class _Big extends StatelessWidget {
  const _Big(this.label, {required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: context.veyro.acc,
        foregroundColor: VeyroColors.onAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label.toUpperCase(),
        style: VeyroText.display(
          22,
          color: VeyroColors.onAccent,
        ).copyWith(letterSpacing: 1.3),
      ),
    ),
  );
}
