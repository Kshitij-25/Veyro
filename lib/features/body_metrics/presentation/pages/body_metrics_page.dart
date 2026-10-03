import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/error_view.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_cubit.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_state.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/progress_photos/presentation/cubit/check_ins_cubit.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/personal_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Root of the Progress tab: weight trend and body measurements.
class BodyMetricsPage extends StatelessWidget {
  const BodyMetricsPage({super.key});

  static const _ranges = {30: '30d', 90: '90d', 180: '6m', 365: '1y'};

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<BodyMetricsCubit, BodyMetricsState>(
          listenWhen: (previous, current) =>
              current.failure != null && current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.failure!.message))),
          builder: (context, state) {
            if (state.status.isPending) return const LoadingView();
            if (state.status.isFailure && state.measurements.isEmpty) {
              return ErrorView(
                message: state.failure?.message ?? 'Something went wrong.',
              );
            }
            return ContentConstraint(
              maxWidth: 1100,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                children: [
                  VTitle(
                    'Progress',
                    trailing: Row(
                      children: [
                        VButton(
                          'Goals',
                          style: VButtonStyle.card,
                          onPressed: () => context.go(AppRoutes.goals),
                        ),
                        const SizedBox(width: 8),
                        VButton(
                          'Badges',
                          style: VButtonStyle.card,
                          onPressed: () => context.go(AppRoutes.achievements),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  VTwoColumn(
                    leftFlex: 5,
                    rightFlex: 4,
                    left: [
                      _ProgressSummary(state: state, units: units),
                      VButton(
                        '+ Log weight',
                        height: 52,
                        radius: 16,
                        expand: true,
                        onPressed: () => _showLogDialog(context, units),
                      ),
                      _ProgressTiles(state: state),
                    ],
                    right: [
                      const _StrengthCard(),
                      _MeasurementRows(state: state, units: units),
                      const Padding(
                        padding: EdgeInsets.only(left: 2, top: 6),
                        child: VLabel('Measurement log'),
                      ),
                      if (state.measurements.isEmpty)
                        const VEmpty('No measurements yet.')
                      else
                        VCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              for (final (i, m) in state.measurements.indexed)
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    10,
                                    8,
                                    10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: i == 0
                                        ? null
                                        : Border(
                                            top: BorderSide(color: v.line),
                                          ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              [
                                                if (m.weightKg != null)
                                                  units.formatWeight(
                                                    m.weightKg!,
                                                  ),
                                                if (m.bodyFatPercent != null)
                                                  '${m.bodyFatPercent!.toStringAsFixed(1)}% fat',
                                                if (m.waistCm != null)
                                                  'waist ${units.formatLength(m.waistCm!)}',
                                              ].join(' · '),
                                              style: VeyroText.body(
                                                15,
                                                weight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat.yMMMd().format(
                                                m.measuredAt,
                                              ),
                                              style: VeyroText.body(
                                                12,
                                                color: v.mute,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      VTextAction(
                                        'Delete',
                                        onPressed: () => context
                                            .read<BodyMetricsCubit>()
                                            .delete(m.id),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
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

class _ProgressSummary extends StatefulWidget {
  const _ProgressSummary({required this.state, required this.units});

  final BodyMetricsState state;
  final UnitSystem units;

  @override
  State<_ProgressSummary> createState() => _ProgressSummaryState();
}

class _ProgressSummaryState extends State<_ProgressSummary> {
  /// Index of the chart point being scrubbed, or null for the latest.
  int? _scrub;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = widget.units;
    final progress = widget.state.progress;
    final points = progress.weightPoints;
    final change = progress.changeKg;
    final index = points.isEmpty
        ? null
        : (_scrub ?? points.length - 1).clamp(0, points.length - 1);
    final shown = index == null ? null : points[index];
    return VCard(
      radius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VLabel(
                      _scrub == null || shown == null
                          ? 'Weight'
                          : DateFormat.MMMd().format(shown.date),
                    ),
                    Text.rich(
                      TextSpan(
                        text: shown == null
                            ? '—'
                            : UnitConverter.weightToDisplay(
                                shown.weightKg,
                                units,
                              ).toStringAsFixed(1),
                        children: [
                          TextSpan(
                            text: ' ${units.weightUnit}',
                            style: VeyroText.display(22, color: v.mute),
                          ),
                        ],
                      ),
                      style: VeyroText.display(66, height: .9),
                    ),
                    if (change != null)
                      Text(
                        '${change >= 0 ? '+' : ''}${UnitConverter.weightToDisplay(change, units).toStringAsFixed(1)} '
                        '${units.weightUnit} over ${widget.state.progressDays} days',
                        style: VeyroText.body(12.5, weight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              if (progress.bmi != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      progress.bmi!.toStringAsFixed(1),
                      style: VeyroText.display(32),
                    ),
                    Text('BMI', style: VeyroText.body(11.5, color: v.mute)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (d) =>
                  _scrubTo(d.localPosition.dx, c.maxWidth, points.length),
              onPanUpdate: (d) =>
                  _scrubTo(d.localPosition.dx, c.maxWidth, points.length),
              onPanEnd: (_) => setState(() => _scrub = null),
              onPanCancel: () => setState(() => _scrub = null),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: CustomPaint(
                  painter: _WeightChartPainter(
                    values: [for (final p in points) p.weightKg],
                    selected: index,
                    accent: v.acc,
                    ink: v.ink,
                    card: v.card,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          VSegmented<int>(
            options: BodyMetricsPage._ranges,
            selected: widget.state.progressDays,
            height: 32,
            onChanged: context.read<BodyMetricsCubit>().setProgressDays,
          ),
        ],
      ),
    );
  }

  void _scrubTo(double dx, double width, int count) {
    if (count < 2) return;
    setState(
      () => _scrub = (dx / width * (count - 1)).round().clamp(0, count - 1),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.values,
    required this.selected,
    required this.accent,
    required this.ink,
    required this.card,
  });

  final List<double> values;
  final int? selected;
  final Color accent;
  final Color ink;
  final Color card;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final lo = values.reduce((a, b) => a < b ? a : b);
    final hi = values.reduce((a, b) => a > b ? a : b);
    final span = (hi - lo).clamp(0.5, double.infinity);
    Offset at(int i) => Offset(
      i / (values.length - 1) * size.width,
      size.height - 8 - (values[i] - lo) / span * (size.height - 24),
    );
    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = accent.withValues(alpha: .14));
    canvas.drawPath(
      line,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final i = selected;
    if (i != null) {
      final p = at(i);
      canvas.drawLine(
        Offset(p.dx, 0),
        Offset(p.dx, size.height),
        Paint()..color = ink.withValues(alpha: .25),
      );
      canvas.drawCircle(p, 9, Paint()..color = card);
      canvas.drawCircle(p, 6, Paint()..color = accent);
    }
  }

  @override
  bool shouldRepaint(_WeightChartPainter old) =>
      old.values != values || old.selected != selected;
}

class _ProgressTiles extends StatelessWidget {
  const _ProgressTiles({required this.state});

  final BodyMetricsState state;

  @override
  Widget build(BuildContext context) {
    final summary = context.watch<DashboardCubit>().state.summary;
    final sleep = summary?.recovery?.lastSleepMinutes;
    final checkIns = context.watch<CheckInsCubit>().state.checkIns;
    final readiness = summary?.readiness;
    final report = summary?.weeklyReport;
    final fat = state.measurements
        .where((m) => m.bodyFatPercent != null)
        .map((m) => m.bodyFatPercent!)
        .firstOrNull;
    return WellnessBuilder(
      builder: (context, store) {
        final tiles = [
          (
            'Sleep',
            sleep == null ? '—' : '${sleep ~/ 60}h ${sleep % 60}m',
            AppRoutes.sleep,
          ),
          (
            'Recovery',
            readiness == null ? '—' : '${readiness.score} · ${readiness.label}',
            AppRoutes.recovery,
          ),
          (
            'Body composition',
            fat == null ? 'Not logged' : '${fat.toStringAsFixed(1)}% fat',
            AppRoutes.bodyComposition,
          ),
          (
            'Photos',
            checkIns.isEmpty
                ? 'None yet'
                : '${checkIns.length} check-in${checkIns.length == 1 ? '' : 's'}',
            AppRoutes.photos,
          ),
          (
            'Habits',
            store.habits.isEmpty
                ? 'None yet'
                : '${store.habitsDone} of ${store.habits.length} today',
            AppRoutes.habits,
          ),
          (
            'Weekly report',
            report == null
                ? '—'
                : '${report.workouts} ${report.workouts == 1 ? 'workout' : 'workouts'}',
            AppRoutes.report,
          ),
        ];
        return VGrid2(
          children: [
            for (final t in tiles)
              VStatTile(
                label: t.$1,
                value: t.$2,
                valueSize: 26,
                onTap: () => context.go(t.$3),
              ),
          ],
        );
      },
    );
  }
}

class _StrengthCard extends StatelessWidget {
  const _StrengthCard();

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    final v = context.veyro;
    return BlocBuilder<PersonalRecordsCubit, PersonalRecordsState>(
      builder: (context, state) {
        double? e1(String key) {
          final match = state.records
              .where((r) => r.exercise.name.toLowerCase().contains(key))
              .map((r) => r.estimatedOneRepMaxKg);
          return match.isEmpty ? null : match.reduce((a, b) => a > b ? a : b);
        }

        final lifts = [
          ('Bench Press', e1('bench')),
          ('Squat', e1('squat')),
          ('Deadlift', e1('deadlift')),
        ];
        final total = lifts.fold(0.0, (a, b) => a + (b.$2 ?? 0));
        return VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('Estimated 1RM · big three'),
              const SizedBox(height: 6),
              for (final l in lifts)
                VKeyValueRow(
                  label: l.$1,
                  height: 44,
                  value: Text(
                    l.$2 == null
                        ? '—'
                        : '${units.fw(l.$2!)} ${units.weightUnit}',
                    style: VeyroText.display(24),
                  ),
                ),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: v.line)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: VeyroText.body(15, weight: FontWeight.w700),
                    ),
                    Text(
                      total == 0
                          ? '—'
                          : '${units.fw(total)} ${units.weightUnit}',
                      style: VeyroText.display(28),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MeasurementRows extends StatelessWidget {
  const _MeasurementRows({required this.state, required this.units});

  final BodyMetricsState state;
  final UnitSystem units;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final sites =
        <
          (
            String,
            double? Function(BodyMeasurement),
            LogBodyMeasurementParams Function(double),
          )
        >[
          (
            'Waist',
            (m) => m.waistCm,
            (cm) => LogBodyMeasurementParams(waistCm: cm),
          ),
          (
            'Chest',
            (m) => m.chestCm,
            (cm) => LogBodyMeasurementParams(chestCm: cm),
          ),
          (
            'Hips',
            (m) => m.hipsCm,
            (cm) => LogBodyMeasurementParams(hipsCm: cm),
          ),
          ('Arm', (m) => m.armCm, (cm) => LogBodyMeasurementParams(armCm: cm)),
          (
            'Thigh',
            (m) => m.thighCm,
            (cm) => LogBodyMeasurementParams(thighCm: cm),
          ),
        ];
    BodyMeasurement? latest(double? Function(BodyMeasurement) get) =>
        state.measurements.where((m) => get(m) != null).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 8),
          child: VLabel('Body measurements'),
        ),
        VCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final (i, s) in sites.indexed)
                Builder(
                  builder: (context) {
                    final m = latest(s.$2);
                    return InkWell(
                      onTap: () async {
                        final cubit = context.read<BodyMetricsCubit>();
                        final text = await showVeyroInputSheet(
                          context,
                          title: 'Log ${s.$1.toLowerCase()}',
                          label: s.$1,
                          unit: units.lengthUnit,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          initial: m == null ? '' : units.fl(s.$2(m)!),
                        );
                        final n = tryParseDecimal(text);
                        if (n != null) {
                          await cubit.log(
                            s.$3(UnitConverter.lengthFromDisplay(n, units)),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          border: i == 0
                              ? null
                              : Border(top: BorderSide(color: v.line)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.$1,
                                    style: VeyroText.body(
                                      15,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    m == null
                                        ? 'Not logged'
                                        : DateFormat.MMMd().format(
                                            m.measuredAt,
                                          ),
                                    style: VeyroText.body(12, color: v.mute),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: m == null ? '—' : units.fl(s.$2(m)!),
                                children: [
                                  TextSpan(
                                    text: ' ${units.lengthUnit}',
                                    style: VeyroText.body(13, color: v.mute),
                                  ),
                                ],
                              ),
                              style: VeyroText.display(26),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
