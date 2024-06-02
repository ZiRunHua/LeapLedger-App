import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/util/enter.dart';
part 'model.g.dart';

class BaseTransactionCategoryModel {
  late int id;
  @JsonKey(defaultValue: '')
  late String name;
  @JsonKey(fromJson: Json.iconDataFormJson, toJson: Json.iconDataToJson)
  late IconData icon;
  @JsonKey(defaultValue: IncomeExpense.income)
  late IncomeExpense incomeExpense;

  BaseTransactionCategoryModel({required this.id, required this.name, required this.icon, required this.incomeExpense});
}

class StatusFlagModel {
  late IconData icon;
  late String name;
  late String flagName;
  late bool status;

  StatusFlagModel({IconData? icon, required this.name, required this.flagName, required this.status}) {
    this.icon = icon ?? Icons.arrow_back_outlined;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AmountDateModel {
  late int amount;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime date;
  late DateType type;
  AmountDateModel({required this.amount, required this.type, required this.date});

  factory AmountDateModel.fromJson(Map<String, dynamic> json) => _$AmountDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmountDateModelToJson(this);
}

///金额笔数数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class AmountCountModel {
  @JsonKey(defaultValue: 0)
  late int amount;
  @JsonKey(defaultValue: 0)
  late int count;
  int get average => amount != 0 ? amount ~/ count : 0;
  AmountCountModel(this.amount, this.count);
  factory AmountCountModel.fromJson(Map<String, dynamic> json) => _$AmountCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AmountCountModelToJson(this);

  add(AmountCountModel model) {
    amount += model.amount;
    count += model.count;
  }

  sub(AmountCountModel model) {
    amount -= model.amount;
    count -= model.count;
  }

  bool addTransEditModel(TransactionEditModel editModel) {
    amount += editModel.amount;
    count += 1;
    return true;
  }

  bool subTransEditModel(TransactionEditModel editModel) {
    amount -= editModel.amount;
    count -= 1;
    return true;
  }
}

///带时间的金额笔数数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class AmountCountWithTimeModel extends AmountCountModel {
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime startTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime endTime;
  AmountCountWithTimeModel({
    required int amount,
    required int count,
    required startTime,
    required endTime,
  }) : super(amount, count);

  AmountCountWithTimeModel.fromAmountCountModel(
      {required AmountCountModel model, required DateTime startTime, required DateTime endTime})
      : this(amount: model.amount, count: model.count, startTime: startTime, endTime: endTime);

  factory AmountCountWithTimeModel.fromJson(Map<String, dynamic> json) => _$AmountCountWithTimeModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AmountCountWithTimeModelToJson(this);

  @override
  bool addTransEditModel(TransactionEditModel editModel) {
    if (startTime.isAfter(editModel.tradeTime) || endTime.isBefore(editModel.tradeTime)) {
      return false;
    }
    return super.addTransEditModel(editModel);
  }

  @override
  bool subTransEditModel(TransactionEditModel editModel) {
    if (startTime.isAfter(editModel.tradeTime) || endTime.isBefore(editModel.tradeTime)) {
      return false;
    }
    return super.addTransEditModel(editModel);
  }
}

///收支统计接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class InExStatisticModel {
  late AmountCountModel income;
  late AmountCountModel expense;

  InExStatisticModel({AmountCountModel? income, AmountCountModel? expense}) {
    this.income = income ?? AmountCountModel(0, 0);
    this.expense = expense ?? AmountCountModel(0, 0);
  }
  factory InExStatisticModel.fromJson(Map<String, dynamic> json) => _$InExStatisticModelFromJson(json);
  Map<String, dynamic> toJson() => _$InExStatisticModelToJson(this);

  bool handleTransEditModel({required TransactionEditModel editModel, required bool isAdd}) {
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

///带时间的收支统计接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class InExStatisticWithTimeModel extends InExStatisticModel {
  // 日均收入
  int get dayAverageIncome => income.amount != 0 ? income.amount ~/ numberOfDays : 0;
  // 日均支出
  int get dayAverageExpense => expense.amount != 0 ? expense.amount ~/ numberOfDays : 0;
  late final int numberOfDays;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late final DateTime startTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late final DateTime endTime;
  InExStatisticWithTimeModel({super.income, super.expense, required this.startTime, required this.endTime}) {
    numberOfDays = endTime.add(Duration(seconds: 1)).difference(startTime).inDays;
  }

  factory InExStatisticWithTimeModel.fromJson(Map<String, dynamic> json) => _$InExStatisticWithTimeModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$InExStatisticWithTimeModelToJson(this);

  /// 处理交易 以更新统计数据
  @override
  bool handleTransEditModel({required TransactionEditModel editModel, required bool isAdd}) {
    if (startTime.isAfter(editModel.tradeTime) || endTime.isBefore(editModel.tradeTime)) {
      return false;
    }
    return super.handleTransEditModel(editModel: editModel, isAdd: isAdd);
  }
}
