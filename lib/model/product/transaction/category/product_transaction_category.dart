part of '../../model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class ProductTransactionCategoryModel extends TransactionCategoryBaseModel {
  @JsonKey(defaultValue: '')
  late String uniqueKey;
  ProductTransactionCategoryModel(
      {required super.id, required super.name, required super.icon, required super.incomeExpense});

  factory ProductTransactionCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTransactionCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductTransactionCategoryModelToJson(this);
}
