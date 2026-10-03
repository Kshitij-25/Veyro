import 'dart:async';

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

/// Breathing exercise and mobility/mindfulness sessions (sample data).
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
  static const _sessions = [
    ('Morning mobility', 'Mobility', 8),
    ('Post-run stretch', 'Mobility', 6),
    ('Guided meditation', 'Mindfulness', 10),
    ('Body scan', 'Mindfulness', 15),
    ('Yoga flow', 'Yoga', 20),
    ('Foam rolling', 'Recovery', 10),
    ('Sleep wind-down', 'Sleep', 12),
  ];

  String _pattern = 'Box';
  bool _on = false;
  int _t = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _on = !_on;
      _t = 0;
    });
    _timer?.cancel();
    if (_on) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _t++);
      });
    }
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
        final minutes =
            64 +
            _sessions
                .where((s) => store.mindDone.contains(s.$1))
                .fold(0, (a, s) => a + s.$3);
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
                        GestureDetector(
                          onTap: () => setState(() {
                            _pattern = p;
                            _t = 0;
                          }),
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
            for (final s in _sessions)
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
                            s.$1,
                            style: VeyroText.body(16, weight: FontWeight.w700),
                          ),
                          Text(
                            '${s.$2} · ${s.$3} min',
                            style: VeyroText.body(12.5, color: v.mute),
                          ),
                        ],
                      ),
                    ),
                    VButton(
                      store.mindDone.contains(s.$1) ? 'Done ✓' : 'Start',
                      style: store.mindDone.contains(s.$1)
                          ? VButtonStyle.accent
                          : VButtonStyle.ink,
                      height: 36,
                      onPressed: () => store.toggleMind(s.$1),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
