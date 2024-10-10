part of 'model.dart';

/// 交易编辑模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionEditModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: 0)
  late int userId;
  @JsonKey(defaultValue: 0)
  late int accountId;
  @JsonKey(defaultValue: 0)
  late int categoryId;
  @JsonKey(unknownEnumValue: IncomeExpense.expense)
  late IncomeExpense incomeExpense;
  @JsonKey(defaultValue: 0)
  late int amount;
  @JsonKey(defaultValue: "")
  late String remark;
  @UtcDateTimeConverter()
  late DateTime tradeTime;

  bool get isValid => id > 0;
  TransactionEditModel({
    this.id = 0,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.incomeExpense,
    required this.amount,
    required this.remark,
    required this.tradeTime,
  });
  TransactionEditModel.prototypeData() {
    id = 0;
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

  setLocation(Location l) {
    tradeTime = TZDateTime.from(tradeTime, l);
  }

  String? check() {
    if (categoryId == 0) {
      return "请选择交易类型";
    }
    if (accountId == 0) {
      return "请选择账本";
    }
    if (amount <= 0) {
      return "金额需大于0";
    }
    if (amount > Constant.maxAmount) {
      return "金额过大";
    }
    if (tradeTime.year > Constant.maxYear || tradeTime.year < Constant.minYear) {
      return "时间超过范围";
    }
    return null;
  }
}

/// 交易信息模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionInfoModel extends TransactionEditModel {
  @JsonKey(defaultValue: '')
  late String userName;
  @JsonKey(defaultValue: '')
  late String accountName;
  @JsonKey(fromJson: Json.iconDataFormJson, toJson: Json.iconDataToJson)
  late IconData categoryIcon;
  @JsonKey(defaultValue: '')
  late String categoryName;
  @JsonKey(defaultValue: '')
  late String categoryFatherName;

  TransactionInfoModel({
    super.id = 0,
    super.userId = 0,
    this.userName = '',
    super.accountId = 0,
    this.accountName = '',
    super.incomeExpense = IncomeExpense.expense,
    super.categoryId = 0,
    this.categoryIcon = Json.defaultIconData,
    this.categoryName = '',
    this.categoryFatherName = '',
    super.amount = 0,
    super.remark = '',
    required super.tradeTime,
  });
  factory TransactionInfoModel.fromJson(Map<String, dynamic> json) => _$TransactionInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionInfoModelToJson(this);

  TransactionCategoryBaseModel get categoryBaseModel => TransactionCategoryBaseModel(
      id: categoryId, name: categoryName, icon: categoryIcon, incomeExpense: incomeExpense);

  TransactionInfoModel.prototypeData() : this(tradeTime: DateTime.now().toLocal());
  setAccount(AccountModel account) {
    accountId = account.id;
    accountName = account.name;
  }

  setUser(UserModel user) {
    userId = user.id;
    userName = user.username;
  }

  setCategory(TransactionCategoryModel category) {
    categoryId = category.id;
    categoryName = category.name;
    categoryIcon = category.icon;
    categoryFatherName = category.fatherName;
    incomeExpense = category.incomeExpense;
  }

  TransactionInfoModel copyWith({
    int? id,
    int? userId,
    String? userName,
    int? accountId,
    String? accountName,
    IncomeExpense? incomeExpense,
    int? categoryId,
    IconData? categoryIcon,
    String? categoryName,
    String? categoryFatherName,
    int? amount,
    String? remark,
    DateTime? tradeTime,
  }) {
    return TransactionInfoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      incomeExpense: incomeExpense ?? this.incomeExpense,
      categoryId: categoryId ?? this.categoryId,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryName: categoryName ?? this.categoryName,
      categoryFatherName: categoryFatherName ?? this.categoryFatherName,
      amount: amount ?? this.amount,
      remark: remark ?? this.remark,
      tradeTime: tradeTime ?? this.tradeTime,
    );
  }

  setLocation(Location l) {
    super.setLocation(l);
  }
}

/// 交易模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionModel extends TransactionInfoModel {
  @UtcDateTimeConverter()
  late DateTime createTime;
  @UtcDateTimeConverter()
  late DateTime updateTime;
  TransactionModel({
    super.id = 0,
    super.userId = 0,
    super.userName = '',
    super.accountId = 0,
    super.accountName = '',
    super.incomeExpense = IncomeExpense.expense,
    super.categoryId = 0,
    super.categoryIcon = Json.defaultIconData,
    super.categoryName = '',
    super.categoryFatherName = '',
    super.amount = 0,
    super.remark = '',
    required super.tradeTime,
    required this.createTime,
    required this.updateTime,
  });
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionModel.prototypeData()
      : this(tradeTime: DateTime.now(), createTime: DateTime.now(), updateTime: DateTime.now());

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

  setLocation(Location l) {
    updateTime = TZDateTime.from(tradeTime, l);
    createTime = TZDateTime.from(tradeTime, l);
    super.setLocation(l);
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
  @UtcDateTimeConverter()
  late DateTime? tradeTime;
  @UtcDateTimeConverter()
  late DateTime? createTime;
  @UtcDateTimeConverter()
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

@JsonSerializable(fieldRename: FieldRename.pascal, createFactory: false)
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
  @UtcTZDateTimeConverter()
  TZDateTime startTime;
  @UtcTZDateTimeConverter()
  @JsonKey(toJson: dateTimeToJson, fromJson: null)
  TZDateTime endTime;

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
    TZDateTime? startTime,
    TZDateTime? endTime,
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

  Map<String, dynamic> toJson() => _$TransactionQueryCondModelToJson(this);

  @override
  int get hashCode => super.hashCode;

  bool checkTrans(TransactionModel trans) {
    if (accountId != trans.accountId) {
      return false;
    }
    if (startTime.isAfter(trans.tradeTime) || endTime.isBefore(trans.tradeTime)) {
      return false;
    }
    if (userIds.isNotEmpty && false == userIds.contains(trans.userId)) {
      return false;
    }
    if (categoryIds.isNotEmpty && false == categoryIds.contains(trans.categoryId)) {
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

enum TransactionTimingType implements Comparable<TransactionTimingType> {
  @JsonValue("administrator")
  once(name: '执行一次', value: 'once'),
  @JsonValue("everyDay")
  everyDay(name: '每天', value: 'everyDay'),
  @JsonValue("everyWeek")
  everyWeek(name: '每周', value: 'everyWeek'),
  @JsonValue("everyMonth")
  everyMonth(name: '每月', value: 'everyMonth'),
  @JsonValue("lastDayOfMonth")
  lastDayOfMonth(name: '每月最后一天', value: 'lastDayOfMonth');

  const TransactionTimingType({required this.name, required this.value});
  final String name;
  final String value;
  int compareTo(TransactionTimingType other) {
    return index.compareTo(other.index);
  }

  static int compare(TransactionTimingType a, TransactionTimingType b) => a.compareTo(b);

  static List<SelectOption<TransactionTimingType>> get selectOptions =>
      TransactionTimingType.values.map((type) => type.toSelectOption()).toList();

  SelectOption<TransactionTimingType> toSelectOption() {
    return SelectOption<TransactionTimingType>(name: name, value: this);
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class TransactionTimingModel {
  final int id;
  int accountId;
  int userId;
  TransactionTimingType type;
  int offsetDays;
  @UtcDateTimeConverter()
  DateTime nextTime;
  bool close;
  @UtcDateTimeConverter()
  final DateTime updatedAt;
  @UtcDateTimeConverter()
  final DateTime createdAt;
  TransactionTimingModel({
    required this.id,
    required this.accountId,
    required this.userId,
    required this.type,
    required this.offsetDays,
    required this.nextTime,
    required this.close,
    required this.updatedAt,
    required this.createdAt,
  });
  TransactionTimingModel.prototypeData()
      : this(
          id: 0,
          accountId: 0,
          userId: 0,
          type: TransactionTimingType.everyDay,
          offsetDays: 0,
          nextTime: DateTime.now(),
          close: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  factory TransactionTimingModel.fromJson(Map<String, dynamic> json) => _$TransactionTimingModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionTimingModelToJson(this);

  toDisplay() {
    switch (type) {
      case TransactionTimingType.once:
        return "执行一次";
      case TransactionTimingType.everyDay:
        return "每天";
      case TransactionTimingType.everyWeek:
        return "每" + DateFormat("E").format(nextTime);
      case TransactionTimingType.everyMonth:
        return "每月" + DateFormat("d").format(nextTime);
      case TransactionTimingType.lastDayOfMonth:
        return "每月最后一天";
    }
  }

  updateoffsetDaysByNextTime() {
    switch (type) {
      case TransactionTimingType.once:
        offsetDays = 0;
      case TransactionTimingType.everyDay:
        offsetDays = 1;
      case TransactionTimingType.everyWeek:
        offsetDays = nextTime.weekday;
      case TransactionTimingType.everyMonth:
        offsetDays = nextTime.day;
      case TransactionTimingType.lastDayOfMonth:
        offsetDays = 0;
    }
  }

  TransactionTimingModel copyWith({
    int? id,
    int? accountId,
    int? userId,
    TransactionTimingType? type,
    int? offsetDays,
    DateTime? nextTime,
    bool? close,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) =>
      TransactionTimingModel(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        offsetDays: offsetDays ?? this.offsetDays,
        nextTime: nextTime ?? this.nextTime,
        close: close ?? this.close,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );

  setUser(UserModel user) {
    userId = user.id;
  }

  setAccount(AccountModel account) {
    accountId = account.id;
  }
}

String dateTimeToJson(TZDateTime dateTime) {
  return dateTime.toUtc().toIso8601String();
}
