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
class InExStatisticModel {
  late AmountCountModel income;
  late AmountCountModel expense;

  InExStatisticModel({AmountCountModel? income, AmountCountModel? expense}) {
    this.income = income ?? AmountCountModel(0, 0);
    this.expense = expense ?? AmountCountModel(0, 0);
  }
  factory InExStatisticModel.fromJson(Map<String, dynamic> json) => _$InExStatisticModelFromJson(json);
  Map<String, dynamic> toJson() => _$InExStatisticModelToJson(this);

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