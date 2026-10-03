import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/sleep/domain/entities/sleep_night.dart';
import 'package:fitness_trakcer/features/sleep/domain/repositories/sleep_repository.dart';
import 'package:fitness_trakcer/features/sleep/domain/usecases/get_sleep_nights.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sleep_cubit.freezed.dart';

@freezed
abstract class SleepState with _$SleepState {
  const factory SleepState({
    @Default(ViewStatus.initial) ViewStatus status,

    /// Oldest first.
    @Default([]) List<SleepNight> nights,

    /// Imported history, oldest first.
    @Default([]) List<SleepDay> history,
    Failure? failure,
  }) = _SleepState;
}

@injectable
class SleepCubit extends Cubit<SleepState> {
  SleepCubit(this._getSleepNights, this._repository)
    : super(const SleepState());

  static const nightCount = 7;

  final GetSleepNights _getSleepNights;
  final SleepRepository _repository;

  Future<void> load() async {
    if (state.nights.isEmpty) emit(state.copyWith(status: ViewStatus.loading));
    final history = (await _repository.getHistory()).dataOrNull ?? const [];
    final result = await _getSleepNights(nightCount);
    if (isClosed) return;
    result.when(
      success: (nights) => emit(
        state.copyWith(
          status: ViewStatus.success,
          nights: nights,
          history: history,
          failure: null,
        ),
      ),
      failure: (f) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }
}
