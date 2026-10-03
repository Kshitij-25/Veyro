import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/delete_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_body_progress.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/update_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/watch_body_measurements.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BodyMetricsCubit extends Cubit<BodyMetricsState> {
  BodyMetricsCubit(
    this._watchMeasurements,
    this._getBodyProgress,
    this._logMeasurement,
    this._updateMeasurement,
    this._deleteMeasurement,
    this._clock,
  ) : super(const BodyMetricsState());

  final WatchBodyMeasurements _watchMeasurements;
  final GetBodyProgress _getBodyProgress;
  final LogBodyMeasurement _logMeasurement;
  final UpdateBodyMeasurement _updateMeasurement;
  final DeleteBodyMeasurement _deleteMeasurement;
  final Clock _clock;

  StreamSubscription<List<BodyMeasurement>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchMeasurements(const NoParams()).listen(
      (measurements) async {
        emit(state.copyWith(measurements: measurements));
        await _refreshProgress();
      },
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  Future<void> setProgressDays(int days) async {
    emit(state.copyWith(progressDays: days));
    await _refreshProgress();
  }

  Future<void> _refreshProgress() async {
    final range = DateRange.lastDays(state.progressDays, until: _clock.now());
    final result = await _getBodyProgress(range);
    if (isClosed) return;
    result.when(
      success: (progress) => emit(
        state.copyWith(
          status: ViewStatus.success,
          progress: progress,
          failure: null,
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }

  Future<bool> log(LogBodyMeasurementParams params) async =>
      _report(await _logMeasurement(params));

  Future<bool> update(BodyMeasurement measurement) async =>
      _report(await _updateMeasurement(measurement));

  Future<void> delete(String id) async => _report(await _deleteMeasurement(id));

  bool _report<T>(Result<T> result) {
    final failure = result.failureOrNull;
    emit(state.copyWith(failure: failure));
    return failure == null;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
