import 'package:equatable/equatable.dart';

/// Minutes spent in each heart-rate zone (Z1..Z5) over a period.
class HeartRateZones extends Equatable {
  const HeartRateZones({required this.minutes, required this.maxHr});

  /// Five values, Z1 (50-60% of max) to Z5 (90%+).
  final List<int> minutes;
  final int maxHr;

  int get totalMinutes => minutes.fold(0, (a, b) => a + b);

  @override
  List<Object?> get props => [minutes, maxHr];
}

class HeartRateSampleInput {
  const HeartRateSampleInput(this.time, this.bpm);

  final DateTime time;
  final double bpm;
}

/// Time in elevated heart-rate zones from raw samples. Anything under 50% of
/// max counts as rest and is left out. Each sample is credited the time until
/// the next one, capped at five minutes so gaps in wearing the watch don't
/// inflate a zone.
abstract final class HeartRateZoneCalculator {
  static const _cap = Duration(minutes: 5);

  static HeartRateZones compute(List<HeartRateSampleInput> samples, int maxHr) {
    final seconds = List.filled(5, 0.0);
    for (var i = 0; i < samples.length; i++) {
      final s = samples[i];
      final ratio = s.bpm / maxHr;
      if (ratio < 0.5) continue;
      final zone = ((ratio - 0.5) / 0.1).floor().clamp(0, 4);
      final next = i + 1 < samples.length
          ? samples[i + 1].time.difference(s.time)
          : const Duration(minutes: 1);
      seconds[zone] += (next > _cap ? _cap : next).inSeconds;
    }
    return HeartRateZones(
      minutes: [for (final s in seconds) (s / 60).round()],
      maxHr: maxHr,
    );
  }
}
