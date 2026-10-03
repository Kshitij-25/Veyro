import 'dart:async';

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/data/content/mind_catalogue.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Breathing exercise and guided mobility / mindfulness sessions. Finished
/// sessions are saved and counted as mindful minutes.
class MindPage extends StatefulWidget {
  const MindPage({super.key});

  @override
  State<MindPage> createState() => _MindPageState();
}

class _MindPageState extends State<MindPage> {
  static const _patterns = {
    'Box': [4, 4, 4, 4],
    '4-7-8': [4, 7, 8, 0],
    'Coherent': [5, 0, 5, 0],
  };
  static const _phases = ['Inhale', 'Hold', 'Exhale', 'Hold'];

  String _pattern = 'Box';
  bool _on = false;
  int _t = 0;
  Timer? _timer;
  DateTime? _startedAt;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    final store = WellnessStore.instance;
    if (_on) {
      final started = _startedAt;
      if (started != null) {
        store.logMind('Breathing · $_pattern', 'Breathing', started, _t);
      }
    }
    setState(() {
      _on = !_on;
      _t = 0;
      _startedAt = _on ? DateTime.now() : null;
    });
    _timer?.cancel();
    if (_on) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _t++);
      });
    }
  }

  Future<void> _run(MindSessionPlan plan) async {
    if (_on) _toggle();
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _SessionRunner(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final pt = _patterns[_pattern]!;
    final cycle = pt.fold(0, (a, b) => a + b);
    final tt = _t % cycle;
    var pi = 0;
    var acc = 0;
    for (; pi < 3; pi++) {
      if (tt < acc + pt[pi]) break;
      acc += pt[pi];
    }
    final big = _on && pi < 2;
    return WellnessBuilder(
      builder: (context, store) {
        final minutes = (store.mindSecondsThisWeek / 60).round();
        return VSubPage(
          title: 'Mind &\nmobility',
          maxWidth: 560,
          children: [
            VCard(
              color: v.ink,
              radius: 26,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: AnimatedScale(
                      scale: big ? 1 : .55,
                      duration: Duration(
                        seconds: _on ? pt[pi].clamp(1, 20) : 0,
                        milliseconds: _on ? 0 : 400,
                      ),
                      curve: Curves.linear,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              VeyroColors.accent,
                              VeyroColors.accent,
                              Color(0x40FF5A2B),
                            ],
                            stops: [0, .55, .56],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (_on ? _phases[pi] : 'Ready').toUpperCase(),
                              style: VeyroText.display(
                                26,
                                color: VeyroColors.onAccent,
                              ),
                            ),
                            Text(
                              _on ? '${acc + pt[pi] - tt}' : '',
                              style: VeyroText.display(
                                40,
                                color: VeyroColors.onAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final p in _patterns.keys)
                        Center(
                          widthFactor: 1,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _pattern = p;
                              _t = 0;
                            }),
                            child: Container(
                              height: 34,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: p == _pattern
                                    ? v.bg
                                    : v.mute.withValues(alpha: .25),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Text(
                                p,
                                style: VeyroText.body(
                                  13,
                                  weight: FontWeight.w600,
                                  color: p == _pattern ? v.ink : v.bg,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  VButton(
                    _on ? 'Stop' : 'Begin',
                    height: 50,
                    radius: 16,
                    expand: true,
                    onPressed: _toggle,
                  ),
                ],
              ),
            ),
            VCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const VLabel('Mindful minutes this week'),
                  Text('$minutes', style: VeyroText.display(32)),
                ],
              ),
            ),
            for (final p in mindSessions)
              VCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: VeyroText.body(16, weight: FontWeight.w700),
                          ),
                          Text(
                            '${p.category} · ${p.minutes} min${store.mindDoneToday(p.name) ? ' · done today' : ''}',
                            style: VeyroText.body(12.5, color: v.mute),
                          ),
                        ],
                      ),
                    ),
                    VButton(
                      'Start',
                      style: store.mindDoneToday(p.name)
                          ? VButtonStyle.soft
                          : VButtonStyle.ink,
                      height: 36,
                      onPressed: () => _run(p),
                    ),
                  ],
                ),
              ),
            if (store.mindLog.isNotEmpty)
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VLabel('Recent'),
                    for (final m in store.mindLog.take(5))
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                m.name,
                                style: VeyroText.body(
                                  14.5,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${(m.seconds / 60).toStringAsFixed(m.seconds >= 600 ? 0 : 1)} min · ${_ago(m.startedAt)}',
                              style: VeyroText.body(12.5, color: v.mute),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  static String _ago(DateTime t) {
    final now = DateTime.now();
    final days = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime(t.year, t.month, t.day)).inDays;
    return days == 0
        ? 'today'
        : days == 1
        ? 'yesterday'
        : '$days days ago';
  }
}

/// Full-screen runner: one step at a time with its own countdown.
class _SessionRunner extends StatefulWidget {
  const _SessionRunner({required this.plan});

  final MindSessionPlan plan;

  @override
  State<_SessionRunner> createState() => _SessionRunnerState();
}

class _SessionRunnerState extends State<_SessionRunner> {
  final _startedAt = DateTime.now();
  Timer? _timer;
  int _step = 0;
  int _inStep = 0;
  int _elapsed = 0;
  bool _paused = false;
  bool _finished = false;

  MindSessionPlan get _plan => widget.plan;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_paused || _finished || !mounted) return;
    setState(() {
      _elapsed++;
      _inStep++;
      if (_inStep >= _plan.steps[_step].seconds) _advance();
    });
  }

  void _advance() {
    if (_step + 1 >= _plan.steps.length) {
      _finished = true;
      _save();
      return;
    }
    _step++;
    _inStep = 0;
    if (WellnessStore.instance.haptic) HapticFeedback.lightImpact();
  }

  void _save() => WellnessStore.instance.logMind(
    _plan.name,
    _plan.category,
    _startedAt,
    _elapsed,
  );

  void _end() {
    if (!_finished) _save();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final step = _plan.steps[_step];
    final remaining = step.seconds - _inStep;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: v.ink,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _finished
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'DONE',
                        textAlign: TextAlign.center,
                        style: VeyroText.display(64, color: v.bg),
                      ),
                      Text(
                        '${_plan.name} · ${(_elapsed / 60).round()} min saved to your mindful minutes.',
                        textAlign: TextAlign.center,
                        style: VeyroText.body(
                          15,
                          color: v.bg.withValues(alpha: .7),
                        ),
                      ),
                      const SizedBox(height: 28),
                      VButton(
                        'Close',
                        expand: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _plan.name,
                              style: VeyroText.body(
                                14,
                                color: v.bg.withValues(alpha: .7),
                              ),
                            ),
                          ),
                          Text(
                            'Step ${_step + 1} of ${_plan.steps.length}',
                            style: VeyroText.body(
                              14,
                              color: v.bg.withValues(alpha: .7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _elapsed / _plan.totalSeconds,
                        minHeight: 6,
                        backgroundColor: v.bg.withValues(alpha: .15),
                        valueColor: AlwaysStoppedAnimation(v.acc),
                      ),
                      const Spacer(),
                      Text(
                        step.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: VeyroText.display(40, color: v.bg),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        step.cue,
                        textAlign: TextAlign.center,
                        style: VeyroText.body(
                          17,
                          color: v.bg.withValues(alpha: .85),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '${remaining ~/ 60}:${(remaining % 60).toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        style: VeyroText.display(72, color: v.acc),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: VButton(
                              _paused ? 'Resume' : 'Pause',
                              style: VButtonStyle.soft,
                              height: 50,
                              onPressed: () =>
                                  setState(() => _paused = !_paused),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: VButton(
                              'Skip step',
                              style: VButtonStyle.soft,
                              height: 50,
                              onPressed: () => setState(_advance),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      VButton(
                        'End session',
                        height: 50,
                        expand: true,
                        onPressed: _end,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
