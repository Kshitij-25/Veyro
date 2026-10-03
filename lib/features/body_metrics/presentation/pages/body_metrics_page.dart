import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/empty_view.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_cubit.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_state.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Root of the Progress tab: weight trend and body measurements.
class BodyMetricsPage extends StatelessWidget {
  const BodyMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          IconButton(
            tooltip: 'Goals',
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => context.go(AppRoutes.goals),
          ),
          IconButton(
            tooltip: 'Achievements',
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => context.go(AppRoutes.achievements),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogDialog(context, units),
        icon: const Icon(Icons.add),
        label: const Text('Log'),
      ),
      body: BlocConsumer<BodyMetricsCubit, BodyMetricsState>(
        listenWhen: (previous, current) =>
            current.failure != null && current.failure != previous.failure,
        listener: (context, state) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failure!.message))),
        builder: (context, state) {
          if (state.status.isPending) {
            return const LoadingView();
          }
          if (state.status.isFailure && state.measurements.isEmpty) {
            return ErrorView(
              message: state.failure?.message ?? 'Something went wrong.',
            );
          }
          return ContentConstraint(
            maxWidth: 720,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ProgressSummary(state: state, units: units),
                const SizedBox(height: 16),
                if (state.measurements.isEmpty)
                  const EmptyView(message: 'No measurements yet.')
                else
                  for (final m in state.measurements)
                    ListTile(
                      title: Text(
                        [
                          if (m.weightKg != null)
                            units.formatWeight(m.weightKg!),
                          if (m.bodyFatPercent != null)
                            '${m.bodyFatPercent!.toStringAsFixed(1)}% fat',
                          if (m.waistCm != null)
                            'waist ${units.formatLength(m.waistCm!)}',
                        ].join(' · '),
                      ),
                      subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(m.measuredAt),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            context.read<BodyMetricsCubit>().delete(m.id),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showLogDialog(BuildContext context, UnitSystem units) async {
    final cubit = context.read<BodyMetricsCubit>();
    final weight = TextEditingController();
    final waist = TextEditingController();
    final bodyFat = TextEditingController();
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Log measurements'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weight,
              decoration: InputDecoration(
                labelText: 'Weight (${units.weightUnit})',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              controller: waist,
              decoration: InputDecoration(
                labelText: 'Waist (${units.lengthUnit})',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              controller: bodyFat,
              decoration: const InputDecoration(labelText: 'Body fat (%)'),
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
    final weightValue = tryParseDecimal(weight.text);
    final waistValue = tryParseDecimal(waist.text);
    await cubit.log(
      LogBodyMeasurementParams(
        weightKg: weightValue == null
            ? null
            : UnitConverter.weightFromDisplay(weightValue, units),
        waistCm: waistValue == null
            ? null
            : UnitConverter.lengthFromDisplay(waistValue, units),
        bodyFatPercent: tryParseDecimal(bodyFat.text),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.state, required this.units});

  final BodyMetricsState state;
  final UnitSystem units;

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final change = progress.changeKg;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              progress.currentWeightKg == null
                  ? '—'
                  : units.formatWeight(progress.currentWeightKg!),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (change != null)
              Text(
                '${change >= 0 ? '+' : ''}${UnitConverter.weightToDisplay(change, units).toStringAsFixed(1)} '
                '${units.weightUnit} over ${state.progressDays} days',
              ),
            if (progress.bmi != null)
              Text(
                'BMI ${progress.bmi!.toStringAsFixed(1)} (${progress.bmiCategory!.name})',
              ),
          ],
        ),
      ),
    );
  }
}
