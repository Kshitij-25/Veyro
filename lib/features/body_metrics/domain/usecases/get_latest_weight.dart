import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

/// The user's most recent weight: the latest logged measurement, falling back
/// to the weight entered in their profile.
@lazySingleton
class GetLatestWeight implements UseCase<double?, NoParams> {
  const GetLatestWeight(this._bodyMetrics, this._profile);

  final BodyMetricsRepository _bodyMetrics;
  final ProfileRepository _profile;

  @override
  Future<Result<double?>> call(NoParams params) async {
    final latest = await _bodyMetrics.getLatestWithWeight();
    final measuredWeight = latest.dataOrNull?.weightKg;
    if (measuredWeight != null) return Success(measuredWeight);
    final profile = await _profile.getProfile();
    return profile.map((p) => p?.weightKg);
  }
}
