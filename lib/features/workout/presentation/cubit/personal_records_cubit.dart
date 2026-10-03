import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/personal_record.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/get_personal_records.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'personal_records_cubit.freezed.dart';

@freezed
abstract class PersonalRecordsState with _$PersonalRecordsState {
  const factory PersonalRecordsState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<PersonalRecord> records,
    Failure? failure,
  }) = _PersonalRecordsState;
}

@injectable
class PersonalRecordsCubit extends Cubit<PersonalRecordsState> {
  PersonalRecordsCubit(this._getPersonalRecords)
    : super(const PersonalRecordsState());

  final GetPersonalRecords _getPersonalRecords;

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getPersonalRecords(const NoParams());
    result.when(
      success: (records) =>
          emit(state.copyWith(status: ViewStatus.success, records: records)),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }
}
