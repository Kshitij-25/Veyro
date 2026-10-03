import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/bmi.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_progress.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetBodyProgress implements UseCase<BodyProgress, DateRange> {
  const GetBodyProgress(this._bodyMetrics, this._profile);

  final BodyMetricsRepository _bodyMetrics;
  final ProfileRepository _profile;

  @override
  Future<Result<BodyProgress>> call(DateRange params) async {
    final measurements = await _bodyMetrics.getMeasurements(params);
    if (measurements case Fail(:final failure)) return Fail(failure);

    final points = [
      for (final m in measurements.dataOrNull!)
        if (m.weightKg != null)
          WeightPoint(date: m.measuredAt, weightKg: m.weightKg!),
    ];
    final current = points.isEmpty ? null : points.last.weightKg;

    final profile = (await _profile.getProfile()).dataOrNull;
    final bmi = (current != null && profile != null)
        ? BmiCalculator.calculate(weightKg: current, heightCm: profile.heightCm)
        : null;

    return Success(
      BodyProgress(
        weightPoints: points,
        startWeightKg: points.isEmpty ? null : points.first.weightKg,
        currentWeightKg: current,
        bmi: bmi,
      ),
    );
  }
}
