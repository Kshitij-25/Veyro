import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_details.dart';
import 'package:fitness_trakcer/features/recovery/domain/usecases/get_recovery_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'recovery_details_cubit.freezed.dart';

@freezed
abstract class RecoveryDetailsState with _$RecoveryDetailsState {
  const factory RecoveryDetailsState({
    @Default(ViewStatus.initial) ViewStatus status,
    RecoveryDetails? details,
    Failure? failure,
  }) = _RecoveryDetailsState;
}

@injectable
class RecoveryDetailsCubit extends Cubit<RecoveryDetailsState> {
  RecoveryDetailsCubit(this._getDetails) : super(const RecoveryDetailsState());

  final GetRecoveryDetails _getDetails;

  Future<void> load() async {
    if (state.details == null) emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getDetails(const NoParams());
    if (isClosed) return;
    result.when(
      success: (d) => emit(
        state.copyWith(status: ViewStatus.success, details: d, failure: null),
      ),
      failure: (f) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }
}
