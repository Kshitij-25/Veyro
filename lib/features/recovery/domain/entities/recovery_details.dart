import 'package:equatable/equatable.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/heart_rate_zones.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/muscle_recovery.dart';

class RecoveryDetails extends Equatable {
  const RecoveryDetails({required this.muscles, this.zones});

  final List<MuscleRecovery> muscles;

  /// `null` when heart-rate data or the profile isn't available.
  final HeartRateZones? zones;

  bool get hasTrained => muscles.any((m) => m.lastTrained != null);

  @override
  List<Object?> get props => [muscles, zones];
}
