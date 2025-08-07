import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mm/core/model/base_entity.dart';
part 'installments_entity.freezed.dart';
part 'installments_entity.g.dart';

@freezed
abstract class InstallmentsEntity with _$InstallmentsEntity implements BaseEntity{
const factory InstallmentsEntity({
  required int id,
 @JsonKey(name:'user_id') required int userId,
  required String name,
 @JsonKey(name:'total_amount') required double totalAmount,
 @JsonKey(name:'monthly_amount') required double monthlyAmount,
 @JsonKey(name:'start_date') required String startDate,
  required int months,
 @JsonKey(name:'is_completed') required bool isCompleted,
 @JsonKey(name:'credit_id') required int creditId,
@JsonKey(name: 'created_at') DateTime? createdAt,
@JsonKey(name: 'updated_at') DateTime? updatedAt,
          }) = _InstallmentsEntity;

factory InstallmentsEntity.fromJson(Map<String, dynamic> json) => _$InstallmentsEntityFromJson(json);
}