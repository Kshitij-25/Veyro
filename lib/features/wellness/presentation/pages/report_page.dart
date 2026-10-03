import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// The last seven days compared with the seven before, from your workouts,
/// recorded activities and daily activity.
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final r = context.watch<DashboardCubit>().state.summary?.weeklyReport;
    if (r == null) {
      return const VSubPage(
        title: 'Weekly\nreport',
        maxWidth: 720,
        children: [VEmpty('Loading your week…')],
      );
    }

    String signed(num diff, {String suffix = ''}) =>
        '${diff > 0
            ? '+'
            : diff < 0
            ? '−'
            : ''}${diff.abs()}$suffix';
    String pct(double cur, double prev) =>
        prev <= 0 ? '' : signed(((cur / prev - 1) * 100).round(), suffix: '%');
    Color tone(num diff) =>
        diff >= 0 ? VeyroColors.success : VeyroColors.danger;

    final stats = <(String, String, String, num)>[
      (
        'Workouts',
        '${r.workouts}',
        signed(r.workouts - r.prevWorkouts),
        r.workouts - r.prevWorkouts,
      ),
      (
        'Volume',
        '${thousands(UnitConverter.weightToDisplay(r.volumeKg, units))} ${units.weightUnit}',
        pct(r.volumeKg, r.prevVolumeKg),
        r.volumeKg - r.prevVolumeKg,
      ),
      (
        'Active minutes',
        '${r.activeMinutes}',
        signed(r.activeMinutes - r.prevActiveMinutes),
        r.activeMinutes - r.prevActiveMinutes,
      ),
      (
        'Calories burned',
        thousands(r.caloriesBurned),
        pct(r.caloriesBurned.toDouble(), r.prevCaloriesBurned.toDouble()),
        r.caloriesBurned - r.prevCaloriesBurned,
      ),
      (
        'Avg steps',
        thousands(r.avgSteps),
        r.prevAvgSteps == 0 ? '' : signed(r.avgSteps - r.prevAvgSteps),
        r.avgSteps - r.prevAvgSteps,
      ),
      (
        'Distance',
        '${units.fd(r.distanceKm)} ${units.distanceUnit}',
        r.prevDistanceKm <= 0
            ? ''
            : '${r.distanceKm >= r.prevDistanceKm ? '+' : '−'}${units.fd((r.distanceKm - r.prevDistanceKm).abs())}',
        r.distanceKm - r.prevDistanceKm,
      ),
    ];

    final highlights = <String>[
      if (r.heaviest != null)
        'Heaviest set: ${r.heaviest!.exerciseName}, ${units.fw(r.heaviest!.weightKg)} ${units.weightUnit} × ${r.heaviest!.reps}',
      if (r.longestActivityKm > 0)
        'Longest recorded activity: ${units.fd(r.longestActivityKm)} ${units.distanceUnit}',
      if (r.busiestDay != null)
        '${DateFormat('EEEE').format(r.busiestDay!)} was your busiest day with ${r.busiestMinutes} active minutes',
    ];

    Widget list(String title, List<String> items, String empty) => VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VLabel(title),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(empty, style: VeyroText.body(14, color: v.mute)),
            ),
          for (final t in items)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: v.line)),
              ),
              child: Text(t, style: VeyroText.body(14.5, height: 1.4)),
            ),
        ],
      ),
    );

    final dw = r.workouts - r.prevWorkouts;
    final headline = r.prevWorkouts == 0
        ? '${r.activeMinutes} active minutes'
        : dw == 0
        ? 'Same as last week · ${r.activeMinutes} active minutes'
        : '${dw.abs()} ${dw > 0 ? 'more' : 'fewer'} than last week · ${r.activeMinutes} active minutes';
    final range =
        '${DateFormat.MMMd().format(r.start)} – ${DateFormat.MMMd().format(r.end)}';
    final top = r.minutesPerDay.fold(0, (a, b) => a > b ? a : b);
    final weekdays = [
      for (var i = 0; i < 7; i++)
        DateFormat('E').format(r.start.add(Duration(days: i))).substring(0, 1),
    ];

    return VSubPage(
      title: 'Weekly\nreport',
      maxWidth: 720,
      children: [
        Text(range.toUpperCase(), style: VeyroText.label(color: v.mute)),
        VCard(
          color: v.acc,
          radius: 26,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${r.workouts} ${r.workouts == 1 ? 'WORKOUT' : 'WORKOUTS'}',
                style: VeyroText.display(
                  64,
                  color: VeyroColors.onAccent,
                  height: .9,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                headline,
                style: VeyroText.body(14, color: VeyroColors.onAccent),
              ),
            ],
          ),
        ),
        VGrid2(
          children: [
            for (final s in stats)
              VCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VLabel(s.$1),
                    Text(s.$2, style: VeyroText.display(28, height: 1.1)),
                    Text(
                      s.$3.isEmpty ? 'vs last week: —' : '${s.$3} vs last week',
                      style: VeyroText.body(
                        12,
                        weight: FontWeight.w700,
                        color: s.$3.isEmpty ? v.mute : tone(s.$4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VLabel('Active minutes'),
              const SizedBox(height: 8),
              VBarChart(
                values: [for (final m in r.minutesPerDay) m.toDouble()],
                labels: weekdays,
                colors: [for (var i = 0; i < 7; i++) i == 6 ? v.acc : v.ink],
                maxValue: top == 0 ? 1 : top.toDouble(),
                height: 130,
              ),
            ],
          ),
        ),
        list('Highlights', highlights, 'Complete a workout to see highlights.'),
        list('Insights', r.insights, 'Not enough data yet.'),
      ],
    );
  }
}
