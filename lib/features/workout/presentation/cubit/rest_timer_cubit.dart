import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class RestTimerState {
  const RestTimerState({
    this.total = Duration.zero,
    this.remaining = Duration.zero,
    this.finishedCount = 0,
  });

  final Duration total;
  final Duration remaining;

  /// Increments every time a countdown reaches zero, so the UI can react
  /// (sound, haptics) with a `BlocListener`.
  final int finishedCount;

  bool get isRunning => remaining > Duration.zero;

  double get progress => total == Duration.zero
      ? 0
      : 1 - remaining.inMilliseconds / total.inMilliseconds;

  RestTimerState copyWith({
    Duration? total,
    Duration? remaining,
    int? finishedCount,
  }) => RestTimerState(
    total: total ?? this.total,
    remaining: remaining ?? this.remaining,
    finishedCount: finishedCount ?? this.finishedCount,
  );
}

/// Countdown used for rest periods between sets.
@lazySingleton
class RestTimerCubit extends Cubit<RestTimerState> {
  RestTimerCubit() : super(const RestTimerState());

  Timer? _timer;

  void start(Duration duration) {
    _timer?.cancel();
    emit(state.copyWith(total: duration, remaining: duration));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void addTime(Duration extra) {
    if (!state.isRunning) return;
    emit(
      state.copyWith(
        total: state.total + extra,
        remaining: state.remaining + extra,
      ),
    );
  }

  void skip() {
    _timer?.cancel();
    emit(state.copyWith(remaining: Duration.zero));
  }

  void _tick() {
    final next = state.remaining - const Duration(seconds: 1);
    if (next <= Duration.zero) {
      _timer?.cancel();
      emit(
        state.copyWith(
          remaining: Duration.zero,
          finishedCount: state.finishedCount + 1,
        ),
      );
    } else {
      emit(state.copyWith(remaining: next));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
