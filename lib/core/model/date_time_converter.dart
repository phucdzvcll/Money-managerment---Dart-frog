

class DateTimeConverter {

  static DateTime? fromJson(DateTime? json) => json;


  static String? toJson(DateTime? object) => object?.toIso8601String();
}
