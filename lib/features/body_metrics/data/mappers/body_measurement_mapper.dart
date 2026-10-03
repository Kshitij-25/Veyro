import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';

extension BodyMeasurementRowMapper on BodyMeasurementRow {
  BodyMeasurement toEntity() => BodyMeasurement(
    id: id,
    measuredAt: measuredAt,
    weightKg: weightKg,
    bodyFatPercent: bodyFatPercent,
    waistCm: waistCm,
    chestCm: chestCm,
    hipsCm: hipsCm,
    armCm: armCm,
    thighCm: thighCm,
    notes: notes,
  );
}

extension BodyMeasurementEntityMapper on BodyMeasurement {
  BodyMeasurementsCompanion toCompanion() => BodyMeasurementsCompanion(
    id: Value(id),
    measuredAt: Value(measuredAt),
    weightKg: Value(weightKg),
    bodyFatPercent: Value(bodyFatPercent),
    waistCm: Value(waistCm),
    chestCm: Value(chestCm),
    hipsCm: Value(hipsCm),
    armCm: Value(armCm),
    thighCm: Value(thighCm),
    notes: Value(notes),
  );
}
