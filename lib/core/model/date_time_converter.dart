class DateTimeConverter {
  static DateTime? fromJsonNullable(DateTime? json) => json;

  static String? toJsonNullable(DateTime? object) => object?.toIso8601String();

  static DateTime fromJson(DateTime json) => json;

  static String toJson(DateTime object) => object.toIso8601String();
}
