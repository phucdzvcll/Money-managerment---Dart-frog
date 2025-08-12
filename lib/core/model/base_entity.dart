abstract class BaseEntity {
  String get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  Map<String, dynamic> toJson();
}
