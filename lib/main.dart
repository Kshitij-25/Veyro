import 'package:fitness_trakcer/app/app.dart';
import 'package:fitness_trakcer/core/bootstrap/bootstrap.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const App());
}
