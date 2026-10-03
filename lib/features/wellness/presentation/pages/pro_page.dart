import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

/// Veyro Pro upgrade screen. Purchases are not wired up.
class ProPage extends StatelessWidget {
  const ProPage({super.key});

  static const _features = [
    'Unlimited routines and programs',
    'Advanced analytics and weekly reports',
    'Nutrition macros, recipes and fasting',
    'Recovery and readiness scores',
    'Progress photo comparison',
    'Challenges and private groups',
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => VSubPage(
        title: 'Upgrade',
        maxWidth: 560,
        children: [
          VCard(
            color: v.acc,
            radius: 26,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VLabel('Upgrade', color: VeyroColors.onAccent),
                Text(
                  'VEYRO PRO',
                  style: VeyroText.display(
                    64,
                    color: VeyroColors.onAccent,
                    height: .9,
                  ),
                ),
              ],
            ),
          ),
          VCard(
            child: Column(
              children: [
                for (final f in _features)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '✓',
                          style: VeyroText.body(
                            15,
                            weight: FontWeight.w800,
                            color: v.acc,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(f, style: VeyroText.body(14.5))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              for (final p in const [
                ('Monthly', r'$9.99', 'per month'),
                ('Yearly', r'$59.99', r'per year · $5.00 a month'),
              ])
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: p.$1 == 'Monthly' ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => store.setPlan(p.$1),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: v.card,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: store.plan == p.$1
                                ? v.acc
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VLabel(p.$1),
                            Text(
                              p.$2,
                              style: VeyroText.display(34, height: 1.1),
                            ),
                            Text(
                              p.$3,
                              style: VeyroText.body(12, color: v.mute),
                            ),
                            if (p.$1 == 'Yearly')
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: v.acc,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SAVE 50%',
                                  style: VeyroText.body(
                                    11,
                                    weight: FontWeight.w800,
                                    color: VeyroColors.onAccent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          VButton(
            'Start 7-day free trial',
            height: 52,
            radius: 16,
            expand: true,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Purchases aren\'t available in this build.'),
              ),
            ),
          ),
          Text(
            'Restore purchases · Terms · Privacy',
            textAlign: TextAlign.center,
            style: VeyroText.body(12, color: v.mute),
          ),
        ],
      ),
    );
  }
}
