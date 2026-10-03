import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/personal_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalRecordsPage extends StatelessWidget {
  const PersonalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(title: const Text('Personal records')),
      body: BlocBuilder<PersonalRecordsCubit, PersonalRecordsState>(
        builder: (context, state) {
          if (state.status.isPending) return const LoadingView();
          if (state.status.isFailure) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
              onRetry: context.read<PersonalRecordsCubit>().load,
            );
          }
          if (state.records.isEmpty) {
            return const EmptyView(message: 'Finish a workout to set records.');
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              children: [
                for (final record in state.records)
                  ListTile(
                    title: Text(record.exercise.name),
                    subtitle: Text(
                      'Heaviest ${units.formatWeight(record.maxWeightKg)} · '
                      'est. 1RM ${units.formatWeight(record.estimatedOneRepMaxKg)}',
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
