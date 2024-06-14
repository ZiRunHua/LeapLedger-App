part of 'package:keepaccount_app/model/transaction/category/model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionCategoryModel extends BaseTransactionCategoryModel {
  @JsonKey(defaultValue: 0)
  late int fatherId;
  @JsonKey(defaultValue: 0)
  late int accountId;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime createdAt;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime updatedAt;

  bool get isValid => id > 0;

  TransactionCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required this.fatherId,
    required this.accountId,
    required super.incomeExpense,
    required this.createdAt,
    required this.updatedAt,
  });
  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) => _$TransactionCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionCategoryModelToJson(this);

  TransactionCategoryModel.toAdd(TransactionCategoryFatherModel father)
      : this(
          id: 0,
          name: "",
          icon: Json.defaultIconData,
          accountId: father.accountId,
          fatherId: father.id,
          incomeExpense: father.incomeExpense,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  factory TransactionCategoryModel.prototypeData() {
    return TransactionCategoryModel(
      id: 0,
      name: 'prototypeData',
      icon: Icons.account_circle,
      fatherId: 0,
      accountId: 0,
      incomeExpense: IncomeExpense.expense,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  TransactionCategoryModel copyWith({
    int? id,
    String? name,
    IconData? icon,
    int? fatherId,
    int? accountId,
    IncomeExpense? incomeExpense,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      fatherId: fatherId ?? this.fatherId,
      accountId: accountId ?? this.accountId,
      incomeExpense: incomeExpense ?? this.incomeExpense,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
