import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracked_activities_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TrackedActivitiesPage extends StatelessWidget {
  const TrackedActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return BlocBuilder<TrackedActivitiesCubit, TrackedActivitiesState>(
      builder: (context, state) {
        final Widget? message = state.status.isPending
            ? const LoadingView()
            : state.status.isFailure
            ? VEmpty(state.failure?.message ?? 'Something went wrong.')
            : state.activities.isEmpty
            ? const VEmpty('No recorded activities yet.')
            : null;
        return VSubPage(
          title: 'Recorded activities',
          children: [
            ?message,
            for (final activity in state.activities)
              VCard(
                radius: 20,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                UnitConverter.distanceToDisplay(
                                  activity.distanceMeters,
                                  units,
                                ).toStringAsFixed(2),
                                style: VeyroText.display(30),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${units.distanceUnit} · ${activity.type.label}',
                                style: VeyroText.body(12, color: v.mute),
                              ),
                            ],
                          ),
                          Text(
                            '${DateFormat.MMMd().format(activity.startedAt)} · '
                            '${activity.movingDuration.clock} · '
                            '${units.formatPace(activity.averagePaceSecondsPerKm)} · '
                            '${activity.caloriesKcal.round()} kcal',
                            style: VeyroText.body(12.5, color: v.mute),
                          ),
                        ],
                      ),
                    ),
                    VTextAction(
                      'Delete',
                      onPressed: () => context
                          .read<TrackedActivitiesCubit>()
                          .delete(activity.id),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
