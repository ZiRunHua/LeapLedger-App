part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CommonCaptchaModel {
  @JsonKey(defaultValue: '')
  late String picBase64;
  @JsonKey(defaultValue: '')
  late String captchaId;
  CommonCaptchaModel();
  factory CommonCaptchaModel.fromJson(Map<String, dynamic> json) => _$CommonCaptchaModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommonCaptchaModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)

///金额笔数接口数据模型
class AmountCountApiModel {
  @JsonKey(defaultValue: 0)
  late int amount;
  @JsonKey(defaultValue: 0)
  late int count;
  int get average => amount != 0 ? amount ~/ count : 0;
  AmountCountApiModel(this.amount, this.count);
  factory AmountCountApiModel.fromJson(Map<String, dynamic> json) => _$AmountCountApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$AmountCountApiModelToJson(this);

  add(AmountCountApiModel model) {
    amount += model.amount;
    count += model.count;
  }

  sub(AmountCountApiModel model) {
    amount -= model.amount;
    count -= model.count;
  }

  addTransEditModel(TransactionEditModel model) {
    amount += model.amount;
    count += 1;
  }

  subTransEditModel(TransactionEditModel model) {
    amount -= model.amount;
    count -= 1;
  }
}

///收支统计接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class IncomeExpenseStatisticApiModel {
  late AmountCountApiModel income;
  late AmountCountApiModel expense;

  IncomeExpenseStatisticApiModel({AmountCountApiModel? income, AmountCountApiModel? expense}) {
    this.income = income ?? AmountCountApiModel(0, 0);
    this.expense = expense ?? AmountCountApiModel(0, 0);
  }
  factory IncomeExpenseStatisticApiModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeExpenseStatisticApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeExpenseStatisticApiModelToJson(this);

  bool handleTransEditModel({required TransactionEditModel trans, required bool isAdd}) {
    if (isAdd) {
      if (trans.incomeExpense == IncomeExpense.income) {
        income.addTransEditModel(trans);
      } else {
        expense.addTransEditModel(trans);
      }
    } else {
      if (trans.incomeExpense == IncomeExpense.income) {
        income.subTransEditModel(trans);
      } else {
        expense.subTransEditModel(trans);
      }
    }
    return true;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class IncomeExpenseStatisticWithTimeApiModel {
  late AmountCountApiModel income;
  late AmountCountApiModel expense;
  Duration? get timeDuration => endTime.difference(startTime);
  // 日均收入
  int get dayAverageIncome => timeDuration != null && income.amount != 0 ? income.amount ~/ timeDuration!.inDays : 0;
  // 日均支出
  int get dayAverageExpense => timeDuration != null && expense.amount != 0 ? expense.amount ~/ timeDuration!.inDays : 0;

  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime startTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime endTime;
  IncomeExpenseStatisticWithTimeApiModel(
      {AmountCountApiModel? income, AmountCountApiModel? expense, required this.startTime, required this.endTime}) {
    this.income = income ?? AmountCountApiModel(0, 0);
    this.expense = expense ?? AmountCountApiModel(0, 0);
  }

  factory IncomeExpenseStatisticWithTimeApiModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeExpenseStatisticWithTimeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$IncomeExpenseStatisticWithTimeApiModelToJson(this);

  /// 处理交易 以更新统计数据
  bool handleTransEditModel({required TransactionEditModel editModel, required bool isAdd}) {
    if (startTime.isAfter(editModel.tradeTime) || endTime.isBefore(editModel.tradeTime)) {
      return false;
    }
    if (isAdd) {
      if (editModel.incomeExpense == IncomeExpense.income) {
        income.addTransEditModel(editModel);
      } else {
        expense.addTransEditModel(editModel);
      }
    } else {
      if (editModel.incomeExpense == IncomeExpense.income) {
        income.subTransEditModel(editModel);
      } else {
        expense.subTransEditModel(editModel);
      }
    }
    return true;
  }
}

///日金额统计接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class DayAmountStatisticApiModel {
  late int amount;

  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  DateTime date;
  DayAmountStatisticApiModel({this.amount = 0, required this.date});

  factory DayAmountStatisticApiModel.fromJson(Map<String, dynamic> json) => _$DayAmountStatisticApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$DayAmountStatisticApiModelToJson(this);
}
