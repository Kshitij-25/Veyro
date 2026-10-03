import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/personal_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalRecordsPage extends StatelessWidget {
  const PersonalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return BlocBuilder<PersonalRecordsCubit, PersonalRecordsState>(
      builder: (context, state) {
        final Widget? message = state.status.isPending
            ? const LoadingView()
            : state.status.isFailure
            ? VEmpty(state.failure?.message ?? 'Something went wrong.')
            : state.records.isEmpty
            ? const VEmpty('Finish a workout to set records.')
            : null;
        return VSubPage(
          title: 'Personal records',
          children: [
            ?message,
            for (final record in state.records)
              VCard(
                radius: 20,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        record.exercise.name,
                        style: VeyroText.body(16, weight: FontWeight.w700),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: UnitConverter.weightToDisplay(
                              record.maxWeightKg,
                              units,
                            ).toStringAsFixed(1),
                            children: [
                              TextSpan(
                                text: ' ${units.weightUnit}',
                                style: VeyroText.display(15, color: v.mute),
                              ),
                            ],
                          ),
                          style: VeyroText.display(32),
                        ),
                        Text(
                          'est. 1RM ${UnitConverter.weightToDisplay(record.estimatedOneRepMaxKg, units).toStringAsFixed(1)} ${units.weightUnit}',
                          style: VeyroText.body(11.5, color: v.mute),
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
}
