import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_period.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/create_goal.dart';
import 'package:fitness_trakcer/features/goals/presentation/cubit/goals_cubit.dart';
import 'package:fitness_trakcer/features/goals/presentation/goal_unit_formatter.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New goal',
        onPressed: () => _create(context, units),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<GoalsCubit, GoalsState>(
        listenWhen: (previous, current) =>
            current.failure != null && current.failure != previous.failure,
        listener: (context, state) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message))),
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          if (state.status.isFailure && state.progress.isEmpty) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
              onRetry: context.read<GoalsCubit>().refresh,
            );
          }
          if (state.progress.isEmpty) {
            return const EmptyView(message: 'Set a goal to get started.');
          }
          return ContentConstraint(
            maxWidth: 720,
            child: RefreshIndicator.adaptive(
              onRefresh: context.read<GoalsCubit>().refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final progress in state.progress)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    progress.goal.type.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                if (progress.isAchieved)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => context
                                      .read<GoalsCubit>()
                                      .delete(progress.goal.id),
                                ),
                              ],
                            ),
                            LinearProgressIndicator(value: progress.fraction),
                            const SizedBox(height: 8),
                            Text(
                              '${progress.goal.type.format(progress.currentValue, units)} of '
                              '${progress.goal.type.format(progress.goal.targetValue, units)}',
                            ),
                            if (progress.goal.type.period != GoalPeriod.overall)
                              Text(
                                'Streak ${progress.currentStreak} '
                                '${progress.goal.type.period == GoalPeriod.daily ? 'days' : 'weeks'} '
                                '(best ${progress.longestStreak})',
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _create(BuildContext context, UnitSystem units) async {
    final cubit = context.read<GoalsCubit>();
    var type = GoalType.dailySteps;
    final target = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<GoalType>(
                value: type,
                isExpanded: true,
                items: [
                  for (final t in GoalType.values)
                    DropdownMenuItem(value: t, child: Text(t.label)),
                ],
                onChanged: (t) => setState(() => type = t ?? type),
              ),
              TextField(
                controller: target,
                decoration: InputDecoration(
                  labelText: 'Target (${type.unitLabel(units)})',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    final value = tryParseDecimal(target.text);
    if (confirmed == true && value != null) {
      await cubit.create(
        CreateGoalParams(
          type: type,
          targetValue: type.fromDisplay(value, units),
        ),
      );
    }
  }
}
