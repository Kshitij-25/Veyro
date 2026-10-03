import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
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
    final v = context.veyro;
    return BlocConsumer<GoalsCubit, GoalsState>(
      listenWhen: (previous, current) =>
          current.failure != null && current.failure != previous.failure,
      listener: (context, state) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
      builder: (context, state) {
        final Widget? message = state.status.isPending
            ? const LoadingView()
            : state.status.isFailure && state.progress.isEmpty
            ? VEmpty(state.failure?.message ?? 'Something went wrong.')
            : state.progress.isEmpty
            ? const VEmpty('Set a goal to get started.')
            : null;
        return VSubPage(
          title: 'Goals',
          action: VButton(
            '+ New',
            height: 36,
            onPressed: () => _create(context, units),
          ),
          children: [
            ?message,
            for (final progress in state.progress)
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            progress.goal.type.label,
                            style: VeyroText.body(17, weight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          progress.isAchieved
                              ? 'DONE'
                              : '${(progress.fraction * 100).round()}%',
                          style: VeyroText.display(26),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    VProgressBar(value: progress.fraction, height: 10),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            [
                              '${progress.goal.type.format(progress.currentValue, units)} of '
                                  '${progress.goal.type.format(progress.goal.targetValue, units)}',
                              if (progress.goal.type.period !=
                                  GoalPeriod.overall)
                                'streak ${progress.currentStreak} '
                                    '${progress.goal.type.period == GoalPeriod.daily ? 'days' : 'weeks'}',
                            ].join(' · '),
                            style: VeyroText.body(12.5, color: v.mute),
                          ),
                        ),
                        VTextAction(
                          'Delete',
                          onPressed: () => context.read<GoalsCubit>().delete(
                            progress.goal.id,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        );
      },
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
