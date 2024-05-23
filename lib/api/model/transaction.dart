part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionCategoryAmountRankApiModel extends AmountCountModel {
  TransactionCategoryModel category;

  TransactionCategoryAmountRankApiModel({
    required int amount,
    required int count,
    required this.category,
  }) : super(amount, count);
  factory TransactionCategoryAmountRankApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryAmountRankApiModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionCategoryAmountRankApiModelToJson(this);
}

toSet(Set<int> value) => value.isEmpty ? null : value.toList();
