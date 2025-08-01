abstract class BaseEntity {
  int get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  Map<String, dynamic> toJson();
}
