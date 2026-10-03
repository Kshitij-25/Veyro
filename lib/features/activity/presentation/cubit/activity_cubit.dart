import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/get_activity_range.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/get_health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/log_manual_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/request_health_access.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/sync_activity_from_health.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/watch_daily_activity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'activity_cubit.freezed.dart';

@freezed
abstract class ActivityState with _$ActivityState {
  const factory ActivityState({
    @Default(ViewStatus.initial) ViewStatus status,
    DailyActivity? today,

    /// The last seven days, oldest first, ending today.
    @Default([]) List<DailyActivity> week,
    @Default(HealthAccessStatus.unknown) HealthAccessStatus healthAccess,
    @Default(false) bool isSyncing,
    Failure? failure,
  }) = _ActivityState;
}

@injectable
class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit(
    this._watchDailyActivity,
    this._getActivityRange,
    this._getHealthAccessStatus,
    this._requestHealthAccess,
    this._syncActivityFromHealth,
    this._logManualActivity,
    this._clock,
  ) : super(const ActivityState());

  static const _syncDays = 7;

  final WatchDailyActivity _watchDailyActivity;
  final GetActivityRange _getActivityRange;
  final GetHealthAccessStatus _getHealthAccessStatus;
  final RequestHealthAccess _requestHealthAccess;
  final SyncActivityFromHealth _syncActivityFromHealth;
  final LogManualActivity _logManualActivity;
  final Clock _clock;

  StreamSubscription<DailyActivity>? _subscription;

  Future<void> start() async {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchDailyActivity(_clock.now()).listen(
      (today) async {
        emit(state.copyWith(today: today, status: ViewStatus.success));
        await _loadWeek();
      },
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );

    final access = await _getHealthAccessStatus(const NoParams());
    emit(state.copyWith(healthAccess: access.dataOrNull ?? state.healthAccess));
    if (state.healthAccess == HealthAccessStatus.granted) await sync();
  }

  /// Asks for health access and, if granted, imports the last week.
  Future<void> connectHealth() async {
    final result = await _requestHealthAccess(const NoParams());
    emit(
      state.copyWith(
        healthAccess: result.dataOrNull ?? state.healthAccess,
        failure: result.failureOrNull,
      ),
    );
    if (result.dataOrNull == HealthAccessStatus.granted) await sync();
  }

  Future<void> sync() async {
    emit(state.copyWith(isSyncing: true, failure: null));
    final result = await _syncActivityFromHealth(
      DateRange.lastDays(_syncDays, until: _clock.now()),
    );
    emit(state.copyWith(isSyncing: false, failure: result.failureOrNull));
    await _loadWeek();
  }

  Future<bool> logManual({
    required int steps,
    double distanceMeters = 0,
    double activeCaloriesKcal = 0,
  }) async {
    final result = await _logManualActivity(
      LogManualActivityParams(
        date: _clock.now(),
        steps: steps,
        distanceMeters: distanceMeters,
        activeCaloriesKcal: activeCaloriesKcal,
      ),
    );
    emit(state.copyWith(failure: result.failureOrNull));
    return result.isSuccess;
  }

  Future<void> _loadWeek() async {
    final result = await _getActivityRange(
      DateRange.lastDays(_syncDays, until: _clock.now()),
    );
    if (isClosed) return;
    result.when(
      success: (week) => emit(state.copyWith(week: week)),
      failure: (failure) => emit(state.copyWith(failure: failure)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
