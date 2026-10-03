import 'package:fitness_trakcer/core/utils/result.dart';

class ProgramEnrollment {
  const ProgramEnrollment(this.programId, this.startedAt);

  final String programId;
  final DateTime startedAt;
}

abstract interface class ProgramRepository {
  Future<Result<ProgramEnrollment?>> getEnrollment();

  Future<Result<void>> enroll(String programId, DateTime startedAt);

  Future<Result<void>> leave();
}
