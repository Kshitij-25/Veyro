import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ExportAllData implements UseCase<String, NoParams> {
  const ExportAllData(this._repository);

  final DataManagementRepository _repository;

  @override
  Future<Result<String>> call(NoParams params) => _repository.exportToFile();
}

@lazySingleton
class DeleteAllData implements UseCase<void, NoParams> {
  const DeleteAllData(this._repository);

  final DataManagementRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.deleteEverything();
}

@lazySingleton
class RestoreAllData implements UseCase<int, String> {
  const RestoreAllData(this._repository);

  final DataManagementRepository _repository;

  @override
  Future<Result<int>> call(String path) => _repository.restoreFromFile(path);
}
