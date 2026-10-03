import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/goals/presentation/cubit/achievements_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          if (state.status.isFailure) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
              onRetry: context.read<AchievementsCubit>().load,
            );
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              children: [
                for (final achievement in state.achievements)
                  ListTile(
                    enabled: achievement.isUnlocked,
                    leading: Icon(
                      achievement.isUnlocked
                          ? Icons.emoji_events
                          : Icons.lock_outline,
                    ),
                    title: Text(achievement.type.title),
                    subtitle: Text(achievement.type.description),
                    trailing: achievement.isUnlocked
                        ? Text(
                            MaterialLocalizations.of(context)
                                .formatShortDate(achievement.unlockedAt!),
                          )
                        : null,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
