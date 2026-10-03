/// An exercise as returned by the wger `exerciseinfo` endpoint (only the
/// fields the app uses).
class WgerExerciseDto {
  const WgerExerciseDto({
    required this.uuid,
    required this.name,
    required this.categoryName,
    required this.primaryMuscleIds,
    required this.equipmentNames,
    this.description,
    this.imageUrl,
  });

  factory WgerExerciseDto.fromJson(Map<String, dynamic> json) {
    final translations = (json['translations'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    // The request is already filtered to English (language id 2).
    final translation =
        translations.where((t) => t['language'] == 2).firstOrNull ??
        translations.firstOrNull;

    final images = (json['images'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final mainImage =
        images.where((i) => i['is_main'] == true).firstOrNull ??
        images.firstOrNull;

    return WgerExerciseDto(
      uuid: json['uuid'] as String? ?? '',
      name: (translation?['name'] as String? ?? '').trim(),
      description: translation?['description'] as String?,
      categoryName:
          (json['category'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      primaryMuscleIds: [
        for (final m in (json['muscles'] as List<dynamic>? ?? const []))
          (m as Map<String, dynamic>)['id'] as int,
      ],
      equipmentNames: [
        for (final e in (json['equipment'] as List<dynamic>? ?? const []))
          (e as Map<String, dynamic>)['name'] as String,
      ],
      imageUrl: mainImage?['image'] as String?,
    );
  }

  final String uuid;
  final String name;
  final String categoryName;
  final List<int> primaryMuscleIds;
  final List<String> equipmentNames;

  /// HTML, as provided by wger.
  final String? description;
  final String? imageUrl;
}
