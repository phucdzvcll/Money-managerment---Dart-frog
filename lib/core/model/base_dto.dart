abstract class BaseDto {
  int? get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  Map<String, dynamic> toJson();
}

abstract class BaseResponseDto {
  Map<String, dynamic> toJson();
}
