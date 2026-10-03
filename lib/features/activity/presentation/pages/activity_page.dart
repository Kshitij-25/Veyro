import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Root of the Activity tab: today's steps/distance/calories and the week.
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          IconButton(
            tooltip: 'Recorded activities',
            icon: const Icon(Icons.history),
            onPressed: () => context.go(AppRoutes.trackingHistory),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.tracking),
        icon: const Icon(Icons.directions_run),
        label: const Text('Track'),
      ),
      body: BlocConsumer<ActivityCubit, ActivityState>(
        listenWhen: (previous, current) =>
            current.failure != null && current.failure != previous.failure,
        listener: (context, state) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message))),
        builder: (context, state) {
          final today = state.today;
          if (today == null) return const LoadingView();
          return ContentConstraint(
            maxWidth: 720,
            child: RefreshIndicator.adaptive(
              onRefresh: context.read<ActivityCubit>().sync,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${today.steps} steps',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            '${units.formatDistance(today.distanceMeters)} · '
                            '${today.activeCaloriesKcal.round()} kcal',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _HealthAccessTile(state: state, units: units),
                  const SizedBox(height: 8),
                  for (final day in state.week.reversed)
                    ListTile(
                      title: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(day.date),
                      ),
                      trailing: Text('${day.steps} steps'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HealthAccessTile extends StatelessWidget {
  const _HealthAccessTile({required this.state, required this.units});

  final ActivityState state;
  final UnitSystem units;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivityCubit>();
    if (state.healthAccess == HealthAccessStatus.unavailable) {
      return ListTile(
        leading: const Icon(Icons.edit_note),
        title: const Text('Health data unavailable here'),
        subtitle: const Text('Log today\'s activity manually.'),
        onTap: () => _logManually(context),
      );
    }
    if (state.healthAccess == HealthAccessStatus.granted) {
      return ListTile(
        leading: state.isSyncing
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator.adaptive(),
              )
            : const Icon(Icons.sync),
        title: const Text('Synced with Health'),
        onTap: state.isSyncing ? null : cubit.sync,
      );
    }
    return ListTile(
      leading: const Icon(Icons.favorite_outline),
      title: const Text('Connect Health'),
      subtitle: const Text('Import steps, distance and calories.'),
      onTap: cubit.connectHealth,
    );
  }

  Future<void> _logManually(BuildContext context) async {
    final cubit = context.read<ActivityCubit>();
    final steps = TextEditingController();
    final distance = TextEditingController();
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Log activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: steps,
              decoration: const InputDecoration(labelText: 'Steps'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: distance,
              decoration: InputDecoration(
                labelText: 'Distance (${units.distanceUnit})',
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final distanceValue = tryParseDecimal(distance.text) ?? 0;
    await cubit.logManual(
      steps: int.tryParse(steps.text) ?? 0,
      distanceMeters: UnitConverter.distanceFromDisplay(distanceValue, units),
    );
  }
}
