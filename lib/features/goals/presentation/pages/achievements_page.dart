import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/goals/presentation/cubit/achievements_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return BlocBuilder<AchievementsCubit, AchievementsState>(
      builder: (context, state) {
        final unlocked = state.achievements.where((a) => a.isUnlocked).length;
        final Widget? message = state.status.isPending
            ? const LoadingView()
            : state.status.isFailure
            ? VEmpty(state.failure?.message ?? 'Something went wrong.')
            : null;
        return VSubPage(
          title: 'Achievements',
          maxWidth: 960,
          children: [
            Text(
              '$unlocked of ${state.achievements.length} unlocked',
              style: VeyroText.body(13, color: v.mute),
            ),
            ?message,
            LayoutBuilder(
              builder: (context, c) {
                final cols = c.maxWidth >= 640 ? 3 : 2;
                final w = (c.maxWidth - 10 * (cols - 1)) / cols;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final a in state.achievements)
                      SizedBox(
                        width: w,
                        child: Opacity(
                          opacity: a.isUnlocked ? 1 : .55,
                          child: VCard(
                            radius: 20,
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: a.isUnlocked ? v.acc : v.bg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    a.type.title.characters.first,
                                    style: VeyroText.display(
                                      22,
                                      color: a.isUnlocked
                                          ? VeyroColors.onAccent
                                          : v.mute,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  a.type.title,
                                  style: VeyroText.body(
                                    14,
                                    weight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  a.type.description,
                                  style: VeyroText.body(
                                    12,
                                    color: v.mute,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                VProgressBar(
                                  value: a.isUnlocked ? 1 : 0,
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
