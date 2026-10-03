import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/delete_reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/request_reminder_permission.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/save_reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/set_reminder_enabled.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/watch_reminders.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'reminders_cubit.freezed.dart';

@freezed
abstract class RemindersState with _$RemindersState {
  const factory RemindersState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<Reminder> reminders,

    /// The OS refused notification permission, so reminders won't fire.
    @Default(false) bool notificationsDenied,
    Failure? failure,
  }) = _RemindersState;
}

@injectable
class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(
    this._watchReminders,
    this._saveReminder,
    this._setReminderEnabled,
    this._deleteReminder,
    this._requestPermission,
  ) : super(const RemindersState());

  final WatchReminders _watchReminders;
  final SaveReminder _saveReminder;
  final SetReminderEnabled _setReminderEnabled;
  final DeleteReminder _deleteReminder;
  final RequestReminderPermission _requestPermission;

  StreamSubscription<List<Reminder>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchReminders(const NoParams()).listen(
      (reminders) => emit(
        state.copyWith(status: ViewStatus.success, reminders: reminders),
      ),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  /// Creates or updates a reminder (use `Reminder.unsavedId` for new ones).
  Future<bool> save(Reminder reminder) async {
    if (reminder.isEnabled) await _ensurePermission();
    final result = await _saveReminder(reminder);
    emit(state.copyWith(failure: result.failureOrNull));
    return result.isSuccess;
  }

  Future<void> setEnabled(int reminderId, {required bool enabled}) async {
    if (enabled) await _ensurePermission();
    final result = await _setReminderEnabled(
      SetReminderEnabledParams(reminderId, enabled: enabled),
    );
    emit(state.copyWith(failure: result.failureOrNull));
  }

  Future<void> delete(int reminderId) async {
    final result = await _deleteReminder(reminderId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  Future<void> _ensurePermission() async {
    final granted = await _requestPermission(const NoParams());
    emit(state.copyWith(notificationsDenied: granted.dataOrNull != true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
