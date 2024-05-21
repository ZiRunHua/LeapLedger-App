part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionQueryConditionApiModel {
  int accountId;
  @JsonKey(toJson: toSet)
  late Set<int> userIds;
  late Set<int> categoryIds;
  IncomeExpense? incomeExpense;
  int? minimumAmount;
  int? maximumAmount;
  // 起始时间（时间戳）
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  DateTime startTime;
  // 结束时间（时间戳）
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  DateTime endTime;

  TransactionQueryConditionApiModel({
    required this.accountId,
    required this.startTime,
    required this.endTime,
    Set<int>? userIds,
    Set<int>? categoryIds,
    this.incomeExpense,
    this.minimumAmount,
    this.maximumAmount,
  }) {
    this.userIds = userIds ?? {};
    this.categoryIds = categoryIds ?? {};
  }

  TransactionQueryConditionApiModel copyWith({
    int? accountId,
    Set<int>? userIds,
    Set<int>? categoryIds,
    IncomeExpense? incomeExpense,
    int? minimumAmount,
    int? maximumAmount,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TransactionQueryConditionApiModel(
      accountId: accountId ?? this.accountId,
      userIds: userIds ?? this.userIds.toSet(),
      categoryIds: categoryIds ?? this.categoryIds.toSet(),
      incomeExpense: incomeExpense ?? this.incomeExpense,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      maximumAmount: maximumAmount ?? this.maximumAmount,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionQueryConditionApiModel) {
      return false;
    }
    if (other.accountId != accountId) {
      return false;
    }
    if (other.userIds != userIds) {
      return false;
    }
    if (other.categoryIds != categoryIds) {
      return false;
    }
    if (other.incomeExpense != incomeExpense) {
      return false;
    }
    if (other.minimumAmount != minimumAmount) {
      return false;
    }
    if (other.maximumAmount != maximumAmount) {
      return false;
    }
    if (other.startTime != startTime) {
      return false;
    }
    if (other.endTime != endTime) {
      return false;
    }
    return true;
  }

  factory TransactionQueryConditionApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionQueryConditionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionQueryConditionApiModelToJson(this);

  @override
  int get hashCode => super.hashCode;

  bool checkTrans(TransactionModel trans) {
    if (accountId != trans.accountId) {
      return false;
    }
    if (startTime.isAfter(trans.tradeTime) || endTime.isBefore(trans.tradeTime)) {
      return false;
    }
    if (false == userIds.contains(trans.userId)) {
      return false;
    }
    if (false == categoryIds.contains(trans.categoryId)) {
      return false;
    }
    if (incomeExpense != null && incomeExpense != trans.incomeExpense) {
      return false;
    }
    if (minimumAmount != null && minimumAmount! > trans.amount) {
      return false;
    }
    if (maximumAmount != null && maximumAmount! < trans.amount) {
      return false;
    }
    return true;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionCategoryAmountRankApiModel extends AmountCountApiModel {
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
