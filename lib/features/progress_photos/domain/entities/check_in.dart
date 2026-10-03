import 'package:equatable/equatable.dart';

enum PhotoAngle { front, side, back }

/// A dated progress check-in with up to one photo per angle.
class CheckIn extends Equatable {
  const CheckIn({
    required this.id,
    required this.takenAt,
    this.weightKg,
    this.photos = const {},
  });

  final String id;
  final DateTime takenAt;
  final double? weightKg;

  /// Absolute file paths on this device.
  final Map<PhotoAngle, String> photos;

  @override
  List<Object?> get props => [id, takenAt, weightKg, photos];
}
