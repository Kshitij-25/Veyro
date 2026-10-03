import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

/// Root of the Community tab: feed, challenges and leaderboard (sample data;
/// there is no backend, so nothing here is shared with anyone).
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String _tab = 'Feed';
  String _board = 'Friends';

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final wl = units.weightUnit;
    final posts = [
      (
        1,
        'Maya R.',
        'MR',
        '12 min ago',
        'Push Day',
        '62 min · ${thousands(UnitConverter.weightToDisplay(5100, units))} $wl · 2 PRs',
        'Bench finally moved. Slow and steady.',
        14,
        3,
        false,
      ),
      (
        2,
        'Jonas M.',
        'JM',
        '1 h ago',
        'Morning Run',
        '${units.fd(10)} ${units.distanceUnit} · ${clockText(3150 / (10 * units.kmFactor))} /${units.distanceUnit}',
        'Cold and quiet, easy effort.',
        22,
        5,
        true,
      ),
      (
        3,
        'Priya S.',
        'PS',
        '3 h ago',
        'Reached 50% of October 100 Miles',
        '${units.fd(80.5)} ${units.distanceUnit} logged',
        '',
        41,
        9,
        false,
      ),
      (
        4,
        'Leo T.',
        'LT',
        'Yesterday',
        'Leg Day',
        '71 min · ${thousands(UnitConverter.weightToDisplay(8600, units))} $wl',
        '',
        8,
        1,
        false,
      ),
    ];
    final challenges = [
      (
        1,
        'October 100 Miles',
        'Run or walk ${units.fd(160.9, 0)} ${units.distanceUnit} this month',
        2481,
        '28 days',
        80.7,
        160.9,
      ),
      (
        2,
        '10K Steps Streak',
        'Hit 10,000 steps for 14 days',
        9120,
        '11 days',
        6.0,
        14.0,
      ),
      (3, 'Squat Month', 'Log 2,000 squat reps', 733, '20 days', 640.0, 2000.0),
    ];
    final boards = {
      'Friends': [
        ('Priya S.', 412),
        ('Jonas M.', 388),
        ('Maya R.', 361),
        ('You', 342),
        ('Leo T.', 301),
        ('Sam B.', 276),
        ('Ava C.', 244),
      ],
      'Global': [
        ('Kenji O.', 905),
        ('Lars H.', 871),
        ('Dana P.', 840),
        ('Rosa V.', 799),
        ('Priya S.', 412),
        ('You', 342),
      ],
    };
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          maxWidth: 720,
          child: WellnessBuilder(
            builder: (context, store) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                VTitle(
                  'Community',
                  trailing: VButton(
                    'Invite',
                    style: VButtonStyle.card,
                    height: 36,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Invites aren\'t available in this build.',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                VTabs<String>(
                  options: const {
                    'Feed': 'Feed',
                    'Challenges': 'Challenges',
                    'Leaders': 'Leaders',
                  },
                  selected: _tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
                const SizedBox(height: 12),
                if (_tab == 'Feed')
                  for (final p in posts) ...[
                    VCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _Avatar(p.$3, 40),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.$2,
                                      style: VeyroText.body(
                                        15,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      p.$4,
                                      style: VeyroText.body(12, color: v.mute),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            p.$5.toUpperCase(),
                            style: VeyroText.display(26),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.$6,
                            style: VeyroText.body(13.5, color: v.mute),
                          ),
                          if (p.$7.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(p.$7, style: VeyroText.body(14.5)),
                          ],
                          if (p.$10) ...[
                            const SizedBox(height: 10),
                            const VPlaceholder('route map'),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              VButton(
                                'Kudos · ${p.$8 + (store.kudos.contains(p.$1) ? 1 : 0)}',
                                style: store.kudos.contains(p.$1)
                                    ? VButtonStyle.accent
                                    : VButtonStyle.soft,
                                height: 36,
                                onPressed: () => store.toggleKudos(p.$1),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: v.bg,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  '${p.$9} comments',
                                  style: VeyroText.body(
                                    13,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                if (_tab == 'Challenges')
                  for (final c in challenges) ...[
                    VCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            c.$2.toUpperCase(),
                            style: VeyroText.display(28),
                          ),
                          const SizedBox(height: 8),
                          Text(c.$3, style: VeyroText.body(13.5)),
                          const SizedBox(height: 8),
                          Text(
                            '${thousands(c.$4)} joined · ${c.$5} left',
                            style: VeyroText.body(12, color: v.mute),
                          ),
                          const SizedBox(height: 8),
                          VProgressBar(value: c.$6 / c.$7, height: 8),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                c.$1 == 1
                                    ? '${units.fd(c.$6)} of ${units.fd(c.$7, 0)} ${units.distanceUnit}'
                                    : '${c.$6.round()} of ${c.$7.round()}',
                                style: VeyroText.body(13, color: v.mute),
                              ),
                              VButton(
                                store.joined.contains(c.$1) ? 'Joined' : 'Join',
                                style: store.joined.contains(c.$1)
                                    ? VButtonStyle.soft
                                    : VButtonStyle.accent,
                                height: 36,
                                onPressed: () => store.toggleJoined(c.$1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                if (_tab == 'Leaders') ...[
                  VChipRow<String>(
                    options: const {'Friends': 'Friends', 'Global': 'Global'},
                    selected: _board,
                    onChanged: (b) => setState(() => _board = b),
                  ),
                  const SizedBox(height: 12),
                  VCard(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: VLabel('Active minutes this week'),
                        ),
                        for (final (i, r) in boards[_board]!.indexed)
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: r.$1 == 'You' ? v.acc : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    '${i + 1}',
                                    style: VeyroText.display(
                                      20,
                                      color: r.$1 == 'You'
                                          ? VeyroColors.onAccent
                                          : v.ink,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _Avatar(
                                  r.$1.split(' ').map((w) => w[0]).join(),
                                  34,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    r.$1,
                                    style: VeyroText.body(
                                      15,
                                      weight: FontWeight.w700,
                                      color: r.$1 == 'You'
                                          ? VeyroColors.onAccent
                                          : v.ink,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${r.$2} min',
                                  style: VeyroText.display(
                                    20,
                                    color: r.$1 == 'You'
                                        ? VeyroColors.onAccent
                                        : v.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Sample community. Nothing is shared outside this device.',
                  textAlign: TextAlign.center,
                  style: VeyroText.body(12, color: v.mute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.initials, this.size);

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: context.veyro.mute.withValues(alpha: .2),
      shape: BoxShape.circle,
    ),
    child: Text(initials, style: VeyroText.display(size * .4)),
  );
}
