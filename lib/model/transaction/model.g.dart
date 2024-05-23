// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel()
      ..id = (json['Id'] as num?)?.toInt() ?? 0
      ..userId = (json['UserId'] as num?)?.toInt() ?? 0
      ..userName = json['UserName'] as String? ?? ''
      ..accountId = (json['AccountId'] as num?)?.toInt() ?? 0
      ..accountName = json['AccountName'] as String? ?? ''
      ..incomeExpense =
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.income
      ..categoryId = (json['CategoryId'] as num?)?.toInt() ?? 0
      ..categoryIcon = Json.iconDataFormJson(json['CategoryIcon'])
      ..categoryName = json['CategoryName'] as String? ?? ''
      ..categoryFatherName = json['CategoryFatherName'] as String? ?? ''
      ..amount = (json['Amount'] as num?)?.toInt() ?? 0
      ..remark = json['Remark'] as String? ?? ''
      ..tradeTime = Json.dateTimeFromJson(json['TradeTime'])
      ..createTime = Json.dateTimeFromJson(json['CreateTime'])
      ..updateTime = Json.dateTimeFromJson(json['UpdateTime']);

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'UserName': instance.userName,
      'AccountId': instance.accountId,
      'AccountName': instance.accountName,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'CategoryId': instance.categoryId,
      'CategoryIcon': Json.iconDataToJson(instance.categoryIcon),
      'CategoryName': instance.categoryName,
      'CategoryFatherName': instance.categoryFatherName,
      'Amount': instance.amount,
      'Remark': instance.remark,
      'TradeTime': Json.dateTimeToJson(instance.tradeTime),
      'CreateTime': Json.dateTimeToJson(instance.createTime),
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
    };

const _$IncomeExpenseEnumMap = {
  IncomeExpense.income: 'income',
  IncomeExpense.expense: 'expense',
};

TransactionEditModel _$TransactionEditModelFromJson(
        Map<String, dynamic> json) =>
    TransactionEditModel(
      id: (json['Id'] as num?)?.toInt(),
      userId: (json['UserId'] as num).toInt(),
      accountId: (json['AccountId'] as num).toInt(),
      categoryId: (json['CategoryId'] as num).toInt(),
      incomeExpense: $enumDecode(_$IncomeExpenseEnumMap, json['IncomeExpense']),
      amount: (json['Amount'] as num).toInt(),
      remark: json['Remark'] as String,
      tradeTime: Json.dateTimeFromJson(json['TradeTime']),
    );

Map<String, dynamic> _$TransactionEditModelToJson(
        TransactionEditModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'AccountId': instance.accountId,
      'CategoryId': instance.categoryId,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'Amount': instance.amount,
      'Remark': instance.remark,
      'TradeTime': Json.dateTimeToJson(instance.tradeTime),
    };

TransactionShareModel _$TransactionShareModelFromJson(
        Map<String, dynamic> json) =>
    TransactionShareModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.income,
      userName: json['UserName'] as String? ?? '',
      accountName: json['AccountName'] as String? ?? '',
      categoryIcon: Json.optionIconDataFormJson(json['CategoryIcon']),
      categoryName: json['CategoryName'] as String? ?? '',
      categoryFatherName: json['CategoryFatherName'] as String? ?? '',
      remark: json['Remark'] as String? ?? '',
      tradeTime: Json.dateTimeFromJson(json['TradeTime']),
      createTime: Json.dateTimeFromJson(json['CreateTime']),
      updateTime: Json.dateTimeFromJson(json['UpdateTime']),
    );

Map<String, dynamic> _$TransactionShareModelToJson(
        TransactionShareModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserName': instance.userName,
      'AccountName': instance.accountName,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'CategoryIcon': Json.optionIconDataToJson(instance.categoryIcon),
      'CategoryName': instance.categoryName,
      'CategoryFatherName': instance.categoryFatherName,
      'Amount': instance.amount,
      'Remark': instance.remark,
      'TradeTime': Json.dateTimeToJson(instance.tradeTime),
      'CreateTime': Json.dateTimeToJson(instance.createTime),
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
    };

TransactionQueryCondModel _$TransactionQueryCondModelFromJson(
        Map<String, dynamic> json) =>
    TransactionQueryCondModel(
      accountId: (json['AccountId'] as num).toInt(),
      startTime: Json.dateTimeFromJson(json['StartTime']),
      endTime: Json.dateTimeFromJson(json['EndTime']),
      userIds: (json['UserIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet(),
      categoryIds: (json['CategoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet(),
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']),
      minimumAmount: (json['MinimumAmount'] as num?)?.toInt(),
      maximumAmount: (json['MaximumAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionQueryCondModelToJson(
        TransactionQueryCondModel instance) =>
    <String, dynamic>{
      'AccountId': instance.accountId,
      'UserIds': toSet(instance.userIds),
      'CategoryIds': instance.categoryIds.toList(),
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense],
      'MinimumAmount': instance.minimumAmount,
      'MaximumAmount': instance.maximumAmount,
      'StartTime': Json.dateTimeToJson(instance.startTime),
      'EndTime': Json.dateTimeToJson(instance.endTime),
    };
