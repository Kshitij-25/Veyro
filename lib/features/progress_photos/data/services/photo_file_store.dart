import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Keeps progress photos in the app's documents folder.
@lazySingleton
class PhotoFileStore {
  PhotoFileStore();

  String? _dir;

  Future<String> directoryPath() async {
    final cached = _dir;
    if (cached != null) return cached;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'progress_photos'));
    await dir.create(recursive: true);
    return _dir = dir.path;
  }

  /// Copies [sourcePath] in under a fresh name and returns that file name.
  Future<String> save(String sourcePath, String baseName) async {
    final ext = p.extension(sourcePath).isEmpty
        ? '.jpg'
        : p.extension(sourcePath);
    final name = '$baseName-${DateTime.now().millisecondsSinceEpoch}$ext';
    await File(sourcePath).copy(p.join(await directoryPath(), name));
    return name;
  }

  Future<void> delete(String fileName) async {
    final file = File(p.join(await directoryPath(), fileName));
    if (await file.exists()) await file.delete();
  }

  /// Removes every stored photo.
  Future<void> deleteAll() async {
    final dir = Directory(await directoryPath());
    if (await dir.exists()) await dir.delete(recursive: true);
    _dir = null;
  }
}
