class NumbericConverter {
  static double? fromJsonNullAble(dynamic json) {
    if (json is int) {
      return json.toDouble();
    } else if (json is double) {
      return json;
    } else if (json is String) {
      return double.tryParse(json);
    }
  }

  static double fromJson(dynamic json) {
    if (json is int) {
      return json.toDouble();
    } else if (json is double) {
      return json;
    } else if (json is String) {
      return double.tryParse(json) ?? 0;
    }
    return 0;
  }
}
