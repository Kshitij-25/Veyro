import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/layout/window_size_class.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/goals/presentation/goal_unit_formatter.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Root of the Home tab: today at a glance.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            tooltip: 'Profile & settings',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final summary = state.summary;
          if (summary == null) {
            return state.status.isFailure
                ? ErrorView(
                    message: state.failure?.message ?? 'Something went wrong.',
                    onRetry: context.read<DashboardCubit>().load,
                  )
                : const LoadingView();
          }
          final cards = <Widget>[
            _InfoCard(
              title: 'Activity',
              lines: [
                '${summary.activity.steps} steps',
                units.formatDistance(summary.activity.distanceMeters),
                '${summary.activity.activeCaloriesKcal.round()} kcal active',
              ],
            ),
            _InfoCard(
              title: 'Training',
              lines: [
                if (summary.activeWorkout != null)
                  'In progress: ${summary.activeWorkout!.name}',
                '${summary.workoutsThisWeek} workouts this week',
                for (final routine in summary.todaysRoutines)
                  'Planned: ${routine.name}',
              ],
            ),
            if (summary.latestWeightKg != null)
              _InfoCard(
                title: 'Weight',
                lines: [units.formatWeight(summary.latestWeightKg!)],
              ),
            if (summary.goals.isNotEmpty)
              _InfoCard(
                title: 'Goals',
                lines: [
                  for (final goal in summary.goals)
                    '${goal.goal.type.label}: '
                        '${goal.goal.type.format(goal.currentValue, units)} / '
                        '${goal.goal.type.format(goal.goal.targetValue, units)}',
                ],
              ),
          ];
          final columns = WindowSizeClass.of(context).gridColumns;
          return ContentConstraint(
            child: RefreshIndicator.adaptive(
              onRefresh: context.read<DashboardCubit>().load,
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: columns,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: columns == 1 ? 3 : 2,
                children: cards,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            for (final line in lines) Text(line),
          ],
        ),
      ),
    );
  }
}
