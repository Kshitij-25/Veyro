import 'package:equatable/equatable.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';

/// A short rule-based suggestion for today.
class CoachAdvice extends Equatable {
  const CoachAdvice({required this.text, this.routine});

  final String text;

  /// The routine planned for today, when there is one, so the card can offer
  /// to start it.
  final Routine? routine;

  @override
  List<Object?> get props => [text, routine?.id];
}
