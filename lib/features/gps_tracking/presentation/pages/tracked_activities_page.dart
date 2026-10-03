import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracked_activities_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackedActivitiesPage extends StatelessWidget {
  const TrackedActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(title: const Text('Recorded activities')),
      body: BlocBuilder<TrackedActivitiesCubit, TrackedActivitiesState>(
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          if (state.status.isFailure) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
            );
          }
          if (state.activities.isEmpty) {
            return const EmptyView(message: 'No recorded activities yet.');
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              children: [
                for (final activity in state.activities)
                  ListTile(
                    title: Text(
                      '${activity.type.label} · ${units.formatDistance(activity.distanceMeters)}',
                    ),
                    subtitle: Text(
                      '${MaterialLocalizations.of(context).formatMediumDate(activity.startedAt)} · '
                      '${activity.movingDuration.clock} · '
                      '${units.formatPace(activity.averagePaceSecondsPerKm)} · '
                      '${activity.caloriesKcal.round()} kcal',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context
                          .read<TrackedActivitiesCubit>()
                          .delete(activity.id),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
