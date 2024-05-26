part of 'model.dart';

/// 交易模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: 0)
  late int userId;
  @JsonKey(defaultValue: '')
  late String userName;
  @JsonKey(defaultValue: 0)
  late int accountId;
  @JsonKey(defaultValue: '')
  late String accountName;
  @JsonKey(defaultValue: IncomeExpense.income)
  late IncomeExpense incomeExpense;
  @JsonKey(defaultValue: 0)
  late int categoryId;
  @JsonKey(fromJson: Json.iconDataFormJson, toJson: Json.iconDataToJson)
  late IconData categoryIcon;
  @JsonKey(defaultValue: '')
  late String categoryName;
  @JsonKey(defaultValue: '')
  late String categoryFatherName;
  @JsonKey(defaultValue: 0)
  late int amount;
  @JsonKey(defaultValue: '')
  late String remark;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime tradeTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime createTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime updateTime;
  TransactionModel();
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionEditModel get editModel => TransactionEditModel(
      id: id > 0 ? id : null,
      userId: userId,
      accountId: accountId,
      categoryId: categoryId,
      incomeExpense: incomeExpense,
      amount: amount,
      remark: remark,
      tradeTime: tradeTime);

  TransactionShareModel getShareModelByConfig(UserTransactionShareConfigModel config) {
    TransactionShareModel model = TransactionShareModel(
      id: id,
      amount: amount,
      tradeTime: tradeTime,
      incomeExpense: incomeExpense,
      categoryIcon: categoryIcon,
      categoryName: categoryName,
      categoryFatherName: categoryFatherName,
      userName: userName,
    );
    if (config.account) {
      model.accountName = accountName;
    }
    if (config.createTime) {
      model.createTime = createTime;
    }
    if (config.updateTime) {
      model.updateTime = updateTime;
    }
    if (config.remark) {
      model.remark = remark;
    }
    return model;
  }
}

/// 交易编辑模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionEditModel {
  late int? id;
  late int userId;
  late int accountId;
  late int categoryId;
  late IncomeExpense incomeExpense;
  late int amount;
  late String remark;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime tradeTime;
  TransactionEditModel({
    this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.incomeExpense,
    required this.amount,
    required this.remark,
    required this.tradeTime,
  });
  TransactionEditModel.init() {
    id = null;
    userId = 0;
    accountId = 0;
    categoryId = 0;
    incomeExpense = IncomeExpense.expense;
    amount = 0;
    remark = "";
    tradeTime = DateTime.now();
  }
  factory TransactionEditModel.fromJson(Map<String, dynamic> json) => _$TransactionEditModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionEditModelToJson(this);
  TransactionEditModel copy() {
    return TransactionEditModel(
      id: id,
      userId: userId,
      accountId: accountId,
      categoryId: categoryId,
      incomeExpense: incomeExpense,
      amount: amount,
      remark: remark,
      tradeTime: tradeTime,
    );
  }
}

/// 交易分享模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionShareModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: '')
  late String? userName;
  @JsonKey(defaultValue: '')
  late String? accountName;
  @JsonKey(defaultValue: IncomeExpense.income)
  late IncomeExpense incomeExpense;
  @JsonKey(fromJson: Json.optionIconDataFormJson, toJson: Json.optionIconDataToJson)
  late IconData? categoryIcon;
  @JsonKey(defaultValue: '')
  late String? categoryName;
  @JsonKey(defaultValue: '')
  late String? categoryFatherName;
  @JsonKey(defaultValue: 0)
  late int amount;
  @JsonKey(defaultValue: '')
  late String? remark;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime? tradeTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime? createTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime? updateTime;
  TransactionShareModel({
    required this.id,
    required this.amount,
    required this.incomeExpense,
    this.userName,
    this.accountName,
    this.categoryIcon,
    this.categoryName,
    this.categoryFatherName,
    this.remark,
    this.tradeTime,
    this.createTime,
    this.updateTime,
  });
  factory TransactionShareModel.fromJson(Map<String, dynamic> json) => _$TransactionShareModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionShareModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionQueryCondModel {
  int accountId;
  @JsonKey(toJson: toSet)
  late Set<int> userIds;
  @JsonKey(toJson: toSet)
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

  TransactionQueryCondModel({
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

  TransactionQueryCondModel copyWith({
    int? accountId,
    Set<int>? userIds,
    Set<int>? categoryIds,
    IncomeExpense? incomeExpense,
    int? minimumAmount,
    int? maximumAmount,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TransactionQueryCondModel(
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
    if (other is! TransactionQueryCondModel) {
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
    if (!other.startTime.isAtSameMomentAs(startTime)) {
      return false;
    }
    if (!other.endTime.isAtSameMomentAs(endTime)) {
      return false;
    }
    return true;
  }

  factory TransactionQueryCondModel.fromJson(Map<String, dynamic> json) => _$TransactionQueryCondModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionQueryCondModelToJson(this);

  @override
  // ignore: unnecessary_overrides
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
