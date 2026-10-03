import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

/// Daily habits and supplements with streaks (sample data).
class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => VSubPage(
        title: 'Habits &\nsupplements',
        maxWidth: 720,
        action: VButton(
          '+ New',
          height: 36,
          onPressed: () async {
            final name = await showVeyroInputSheet(
              context,
              title: 'New habit',
              label: 'Name',
            );
            if (name != null) store.addHabit(name);
          },
        ),
        children: [
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VLabel('Today'),
                const SizedBox(height: 4),
                Text(
                  store.habits.isEmpty
                      ? 'None yet'
                      : '${store.habitsDone} of ${store.habits.length}',
                  style: VeyroText.display(40),
                ),
                const SizedBox(height: 8),
                VProgressBar(
                  value: store.habits.isEmpty
                      ? 0
                      : store.habitsDone / store.habits.length,
                  height: 8,
                ),
              ],
            ),
          ),
          if (store.habits.isEmpty)
            VCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track what you do every day',
                    style: VeyroText.body(16, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap a suggestion or use + New to add your own.',
                    style: VeyroText.body(13, color: v.mute),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final (name, tag) in const [
                        ('Creatine 5 g', 'Supplement'),
                        ('Vitamin D + Omega-3', 'Supplement'),
                        ('10 min stretching', 'Mobility'),
                        ('No alcohol', 'Lifestyle'),
                        ('In bed before 11 pm', 'Sleep'),
                        ('Protein 150 g+', 'Nutrition'),
                      ])
                        VButton(
                          name,
                          style: VButtonStyle.soft,
                          height: 36,
                          onPressed: () => store.addHabit(name, tag: tag),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          for (final h in store.habits)
            VCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      HabitCheck(habit: h, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.name,
                              style: VeyroText.body(
                                16,
                                weight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${h.tag} · ${h.shownStreak} day streak',
                              style: VeyroText.body(12, color: v.mute),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete habit',
                        onPressed: () => store.removeHabit(h),
                        icon: Icon(Icons.close, size: 18, color: v.mute),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final (i, d) in [...h.week, h.today].indexed)
                        Expanded(
                          child: Container(
                            height: 8,
                            margin: EdgeInsets.only(right: i == 6 ? 0 : 5),
                            decoration: BoxDecoration(
                              color: d ? v.acc : v.bg,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Tappable checkbox for a [Habit].
class HabitCheck extends StatelessWidget {
  const HabitCheck({required this.habit, this.size = 26, super.key});

  final Habit habit;
  final double size;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return GestureDetector(
      onTap: () => WellnessStore.instance.toggleHabit(habit),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: habit.today ? v.acc : Colors.transparent,
          borderRadius: BorderRadius.circular(size * .32),
          border: Border.all(color: habit.today ? v.acc : v.mute, width: 2),
        ),
        child: habit.today
            ? Icon(Icons.check, size: size * .6, color: VeyroColors.onAccent)
            : null,
      ),
    );
  }
}
