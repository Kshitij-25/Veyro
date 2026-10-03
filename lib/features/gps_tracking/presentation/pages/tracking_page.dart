import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Live GPS recording screen. `state.snapshot.route` holds the points so a
/// map widget can draw the path.
class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(title: const Text('Record activity')),
      body: BlocConsumer<TrackingCubit, TrackingState>(
        listenWhen: (previous, current) =>
            (current.failure != null && current.failure != previous.failure) ||
            (current.savedActivity != null && previous.savedActivity == null),
        listener: (context, state) {
          final message =
              state.failure?.message ??
              (state.savedActivity != null ? 'Activity saved' : null);
          if (message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<TrackingCubit>();
          final snapshot = state.snapshot;
          return ContentConstraint(
            maxWidth: 560,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<TrackedActivityType>(
                    segments: [
                      for (final type in TrackedActivityType.values)
                        ButtonSegment(value: type, label: Text(type.label)),
                    ],
                    selected: {state.type},
                    onSelectionChanged: state.status == TrackingStatus.idle
                        ? (s) => cubit.selectType(s.first)
                        : null,
                  ),
                  const Spacer(),
                  Text(
                    (snapshot?.elapsed ?? Duration.zero).clock,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(
                        label: 'Distance',
                        value: units.formatDistance(
                          snapshot?.distanceMeters ?? 0,
                        ),
                      ),
                      _Stat(
                        label: 'Pace',
                        value: units.formatPace(
                          snapshot?.currentPaceSecondsPerKm ?? 0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  switch (state.status) {
                    TrackingStatus.idle => FilledButton(
                      onPressed: state.isSaving ? null : cubit.start,
                      child: const Text('Start'),
                    ),
                    TrackingStatus.tracking => Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: cubit.pause,
                            child: const Text('Pause'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: cubit.finish,
                            child: const Text('Finish'),
                          ),
                        ),
                      ],
                    ),
                    TrackingStatus.paused => Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: cubit.resume,
                            child: const Text('Resume'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: cubit.finish,
                            child: const Text('Finish'),
                          ),
                        ),
                      ],
                    ),
                  },
                  if (state.status != TrackingStatus.idle)
                    TextButton(
                      onPressed: cubit.discard,
                      child: const Text('Discard'),
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

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
