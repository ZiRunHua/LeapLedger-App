part of 'package:leap_ledger_app/model/transaction/category/model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionCategoryFatherModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: 0)
  late int accountId;
  @JsonKey(defaultValue: '')
  late String name;
  @JsonKey(defaultValue: IncomeExpense.income)
  late IncomeExpense incomeExpense;
  @UtcDateTimeConverter()
  late DateTime createdAt;
  @UtcDateTimeConverter()
  late DateTime updatedAt;
  TransactionCategoryFatherModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.incomeExpense,
    required this.createdAt,
    required this.updatedAt,
  });
  factory TransactionCategoryFatherModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionCategoryFatherModelToJson(this);

  bool get isValid => id > 0;
  TransactionCategoryFatherModel copyWith({
    int? id,
    int? accountId,
    String? name,
    IncomeExpense? incomeExpense,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionCategoryFatherModel(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      incomeExpense: incomeExpense ?? this.incomeExpense,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
