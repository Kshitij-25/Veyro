/// Parses user-typed decimals, accepting either `.` or `,` as the separator.
double? tryParseDecimal(String? input) {
  if (input == null) return null;
  final normalized = input.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  return double.tryParse(normalized);
}
