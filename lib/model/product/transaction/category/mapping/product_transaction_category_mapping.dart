part of '../../../model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ProductTransactionCategoryMappingModel {
  @JsonKey(defaultValue: 0)
  late int accountId;
  @JsonKey(defaultValue: 0)
  late int ptcId;
  @JsonKey(defaultValue: 0)
  late int categoryId;
  @JsonKey(defaultValue: 0)
  late int productKey;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  late DateTime createdAt;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  late DateTime updatedAt;
  ProductTransactionCategoryMappingModel();

  factory ProductTransactionCategoryMappingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTransactionCategoryMappingModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductTransactionCategoryMappingModelToJson(this);
}
