/// User-selectable measurement system. All persisted values are metric; this
/// only affects how values are displayed and entered.
enum UnitSystem {
  metric,
  imperial;

  String get weightUnit => this == metric ? 'kg' : 'lb';
  String get lengthUnit => this == metric ? 'cm' : 'in';
  String get distanceUnit => this == metric ? 'km' : 'mi';
}
