import 'dart:async';

import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/get_health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/usecases/request_health_access.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_history.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_sync_report.dart';
import 'package:fitness_trakcer/features/health_sync/domain/repositories/health_sync_repository.dart';
import 'package:fitness_trakcer/features/health_sync/domain/usecases/sync_health_data.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'health_sync_cubit.freezed.dart';

@freezed
abstract class HealthSyncState with _$HealthSyncState {
  const factory HealthSyncState({
    @Default(false) bool loaded,
    @Default(HealthAccessStatus.unknown) HealthAccessStatus access,

    /// The user connected Health before. iOS never says whether read access
    /// was granted, so this is what tells us to keep syncing.
    @Default(false) bool wasConnected,
    @Default(false) bool isSyncing,
    DateTime? lastSync,
    HealthSyncReport? report,

    /// Whole-history import state.
    @Default(false) bool isImportingHistory,
    HealthHistoryProgress? historyProgress,
    @Default(false) bool historyComplete,
    DateTime? historyOldest,
    Failure? failure,
  }) = _HealthSyncState;

  const HealthSyncState._();

  bool get isConnected =>
      access == HealthAccessStatus.granted ||
      (access == HealthAccessStatus.unknown && wasConnected);
}

/// App-wide: keeps data from Apple Health / Health Connect (which also
/// carries Samsung Health, Google Fit, Fitbit...) flowing into the app.
@lazySingleton
class HealthSyncCubit extends Cubit<HealthSyncState> {
  HealthSyncCubit(
    this._getAccess,
    this._requestAccess,
    this._syncHealthData,
    this._repository,
    this._clock,
  ) : super(const HealthSyncState());

  static const _autoDays = 7;
  static const _firstSyncDays = 30;
  static const _staleAfter = Duration(minutes: 15);

  final GetHealthAccessStatus _getAccess;
  final RequestHealthAccess _requestAccess;
  final SyncHealthData _syncHealthData;
  final HealthSyncRepository _repository;
  final Clock _clock;

  /// Reads the connection state and syncs when connected.
  Future<void> start() async {
    final access = await _getAccess(const NoParams());
    emit(
      state.copyWith(
        loaded: true,
        access: access.dataOrNull ?? state.access,
        wasConnected: await _repository.wasConnected(),
        lastSync: await _repository.getLastSync(),
        historyComplete: await _repository.isHistoryComplete(),
        historyOldest: await _repository.getHistoryOldest(),
      ),
    );
    if (state.isConnected && WellnessStore.instance.syncHealth) {
      await sync();
      // Already connected before history import existed: bring it in once.
      if (!state.historyComplete) await importHistory();
    }
  }

  /// Called when the app returns to the foreground.
  Future<void> syncIfStale() async {
    if (!state.loaded) return start();
    final last = state.lastSync;
    if (!state.isConnected || state.isSyncing) return;
    if (!WellnessStore.instance.syncHealth) return;
    if (last != null && _clock.now().difference(last) < _staleAfter) return;
    await sync();
  }

  /// Asks for Health access. Returns as soon as the permission step is over
  /// (whether or not it was granted); the first sync and the history import
  /// carry on in the background, reported through the state.
  Future<bool> connect() async {
    final result = await _requestAccess(const NoParams());
    final access = result.dataOrNull ?? state.access;
    if (access == HealthAccessStatus.granted) {
      await _repository.markConnected();
    }
    emit(
      state.copyWith(
        loaded: true,
        access: access,
        wasConnected: access == HealthAccessStatus.granted
            ? true
            : state.wasConnected,
        failure: result.failureOrNull,
      ),
    );
    if (access == HealthAccessStatus.granted) {
      unawaited(_firstImport());
    }
    return access == HealthAccessStatus.granted;
  }

  Future<void> _firstImport() async {
    await sync(days: _firstSyncDays);
    // First connection: bring in everything Health has.
    if (!state.historyComplete) await importHistory();
  }

  bool _cancelHistory = false;

  /// Imports the whole Health history (newest month first). Takes a while on
  /// a long history; progress is in the state and it can be cancelled.
  Future<void> importHistory() async {
    if (state.isImportingHistory) return;
    _cancelHistory = false;
    emit(
      state.copyWith(
        isImportingHistory: true,
        historyProgress: HealthHistoryProgress(month: _clock.now()),
        failure: null,
      ),
    );
    final result = await _repository.importHistory(
      onProgress: (p) {
        if (!isClosed) emit(state.copyWith(historyProgress: p));
      },
      isCancelled: () => _cancelHistory,
    );
    if (isClosed) return;
    final report = result.dataOrNull;
    emit(
      state.copyWith(
        isImportingHistory: false,
        historyProgress: report?.progress ?? state.historyProgress,
        historyComplete: report?.completed ?? state.historyComplete,
        historyOldest: report?.oldest ?? state.historyOldest,
        lastSync: _clock.now(),
        failure: result.failureOrNull,
      ),
    );
  }

  void cancelHistoryImport() => _cancelHistory = true;

  Future<void> sync({int days = _autoDays}) async {
    if (state.isSyncing) return;
    emit(state.copyWith(isSyncing: true, failure: null));
    final result = await _syncHealthData(days);
    if (isClosed) return;
    emit(
      state.copyWith(
        isSyncing: false,
        report: result.dataOrNull ?? state.report,
        lastSync: result.dataOrNull?.syncedAt ?? state.lastSync,
        failure: result.failureOrNull,
      ),
    );
  }

  Future<void> installHealthConnect() async {
    await _repository.installProvider();
  }
}
