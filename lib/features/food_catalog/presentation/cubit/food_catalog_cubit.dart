import 'dart:async';

import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/repositories/food_catalog_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'food_catalog_cubit.freezed.dart';

@freezed
abstract class FoodCatalogState with _$FoodCatalogState {
  const factory FoodCatalogState({
    @Default('') String query,
    @Default(false) bool isSearching,

    /// Results for [query]; empty when the query is empty.
    @Default([]) List<CatalogFood> results,

    /// Online sources that couldn't be reached for the last search.
    @Default([]) List<String> unreachable,
    @Default([]) List<CatalogFood> recents,
    @Default([]) List<CatalogFood> favorites,
    @Default([]) List<CatalogFood> mine,
    Failure? failure,
  }) = _FoodCatalogState;
}

@injectable
class FoodCatalogCubit extends Cubit<FoodCatalogState> {
  FoodCatalogCubit(this._repository, this._ids)
    : super(const FoodCatalogState());

  final FoodCatalogRepository _repository;
  final IdGenerator _ids;

  StreamSubscription<List<CatalogFood>>? _subscription;
  Timer? _debounce;
  int _searchId = 0;

  void start() {
    _subscription ??= _repository.watchSaved().listen((saved) {
      final recents = saved.where((f) => f.lastUsedAt != null).toList()
        ..sort((a, b) => b.lastUsedAt!.compareTo(a.lastUsedAt!));
      emit(
        state.copyWith(
          recents: recents.take(30).toList(),
          favorites: saved.where((f) => f.isFavorite).toList(),
          mine: saved.where((f) => f.source == FoodSource.custom).toList(),
          // Keep the favourite stars in the visible results current.
          results: [
            for (final r in state.results)
              saved.where((s) => s.id == r.id).firstOrNull ?? r,
          ],
        ),
      );
    });
  }

  /// Debounced search as the user types.
  void search(String query) {
    _debounce?.cancel();
    final q = query.trim();
    if (q.length < 2) {
      _searchId++;
      emit(
        state.copyWith(
          query: query,
          results: [],
          isSearching: false,
          unreachable: [],
        ),
      );
      return;
    }
    emit(state.copyWith(query: query, isSearching: true));
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      final id = ++_searchId;
      final result = await _repository.search(q);
      if (isClosed || id != _searchId) return;
      result.when(
        success: (r) => emit(
          state.copyWith(
            isSearching: false,
            results: r.foods,
            unreachable: r.unreachable,
            failure: null,
          ),
        ),
        failure: (f) => emit(state.copyWith(isSearching: false, failure: f)),
      );
    });
  }

  /// `null` data means the product isn't in the database.
  Future<Result<CatalogFood?>> lookupBarcode(String barcode) =>
      _repository.findByBarcode(barcode);

  Future<void> markUsed(CatalogFood food) => _repository.markUsed(food);

  Future<void> toggleFavorite(CatalogFood food) =>
      _repository.setFavorite(food, favorite: !food.isFavorite);

  Future<bool> createCustom({
    required String name,
    required String serving,
    required double kcal,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    final result = await _repository.saveCustom(
      CatalogFood(
        id: 'custom:${_ids.generate()}',
        source: FoodSource.custom,
        name: name.trim(),
        servingLabel: serving.trim().isEmpty ? '1 serving' : serving.trim(),
        kcal: kcal,
        protein: protein,
        carbs: carbs,
        fat: fat,
      ),
    );
    return result.isSuccess;
  }

  Future<void> deleteSaved(CatalogFood food) =>
      _repository.deleteSaved(food.id);

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
