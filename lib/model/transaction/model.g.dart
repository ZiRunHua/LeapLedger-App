// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionEditModel _$TransactionEditModelFromJson(
        Map<String, dynamic> json) =>
    TransactionEditModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      userId: (json['UserId'] as num?)?.toInt() ?? 0,
      accountId: (json['AccountId'] as num?)?.toInt() ?? 0,
      categoryId: (json['CategoryId'] as num?)?.toInt() ?? 0,
      incomeExpense: $enumDecode(_$IncomeExpenseEnumMap, json['IncomeExpense']),
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      remark: json['Remark'] as String? ?? '',
      tradeTime:
          const UtcDateTimeConverter().fromJson(json['TradeTime'] as String?),
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
      'TradeTime': const UtcDateTimeConverter().toJson(instance.tradeTime),
    };

const _$IncomeExpenseEnumMap = {
  IncomeExpense.income: 'income',
  IncomeExpense.expense: 'expense',
};

TransactionInfoModel _$TransactionInfoModelFromJson(
        Map<String, dynamic> json) =>
    TransactionInfoModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      userId: (json['UserId'] as num?)?.toInt() ?? 0,
      userName: json['UserName'] as String? ?? '',
      accountId: (json['AccountId'] as num?)?.toInt() ?? 0,
      accountName: json['AccountName'] as String? ?? '',
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.expense,
      categoryId: (json['CategoryId'] as num?)?.toInt() ?? 0,
      categoryIcon: json['CategoryIcon'] == null
          ? Json.defaultIconData
          : Json.iconDataFormJson(json['CategoryIcon']),
      categoryName: json['CategoryName'] as String? ?? '',
      categoryFatherName: json['CategoryFatherName'] as String? ?? '',
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      remark: json['Remark'] as String? ?? '',
      tradeTime:
          const UtcDateTimeConverter().fromJson(json['TradeTime'] as String?),
    );

Map<String, dynamic> _$TransactionInfoModelToJson(
        TransactionInfoModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'AccountId': instance.accountId,
      'CategoryId': instance.categoryId,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'Amount': instance.amount,
      'Remark': instance.remark,
      'TradeTime': const UtcDateTimeConverter().toJson(instance.tradeTime),
      'UserName': instance.userName,
      'AccountName': instance.accountName,
      'CategoryIcon': Json.iconDataToJson(instance.categoryIcon),
      'CategoryName': instance.categoryName,
      'CategoryFatherName': instance.categoryFatherName,
    };

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      userId: (json['UserId'] as num?)?.toInt() ?? 0,
      userName: json['UserName'] as String? ?? '',
      accountId: (json['AccountId'] as num?)?.toInt() ?? 0,
      accountName: json['AccountName'] as String? ?? '',
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.expense,
      categoryId: (json['CategoryId'] as num?)?.toInt() ?? 0,
      categoryIcon: json['CategoryIcon'] == null
          ? Json.defaultIconData
          : Json.iconDataFormJson(json['CategoryIcon']),
      categoryName: json['CategoryName'] as String? ?? '',
      categoryFatherName: json['CategoryFatherName'] as String? ?? '',
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      remark: json['Remark'] as String? ?? '',
      tradeTime:
          const UtcDateTimeConverter().fromJson(json['TradeTime'] as String?),
      createTime:
          const UtcDateTimeConverter().fromJson(json['CreateTime'] as String?),
      updateTime:
          const UtcDateTimeConverter().fromJson(json['UpdateTime'] as String?),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'AccountId': instance.accountId,
      'CategoryId': instance.categoryId,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'Amount': instance.amount,
      'Remark': instance.remark,
      'TradeTime': const UtcDateTimeConverter().toJson(instance.tradeTime),
      'UserName': instance.userName,
      'AccountName': instance.accountName,
      'CategoryIcon': Json.iconDataToJson(instance.categoryIcon),
      'CategoryName': instance.categoryName,
      'CategoryFatherName': instance.categoryFatherName,
      'CreateTime': const UtcDateTimeConverter().toJson(instance.createTime),
      'UpdateTime': const UtcDateTimeConverter().toJson(instance.updateTime),
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
      tradeTime:
          const UtcDateTimeConverter().fromJson(json['TradeTime'] as String?),
      createTime:
          const UtcDateTimeConverter().fromJson(json['CreateTime'] as String?),
      updateTime:
          const UtcDateTimeConverter().fromJson(json['UpdateTime'] as String?),
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
      'TradeTime': _$JsonConverterToJson<String?, DateTime>(
          instance.tradeTime, const UtcDateTimeConverter().toJson),
      'CreateTime': _$JsonConverterToJson<String?, DateTime>(
          instance.createTime, const UtcDateTimeConverter().toJson),
      'UpdateTime': _$JsonConverterToJson<String?, DateTime>(
          instance.updateTime, const UtcDateTimeConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

TransactionQueryCondModel _$TransactionQueryCondModelFromJson(
        Map<String, dynamic> json) =>
    TransactionQueryCondModel(
      accountId: (json['AccountId'] as num).toInt(),
      startTime:
          const UtcTZDateTimeConverter().fromJson(json['StartTime'] as String?),
      endTime:
          const UtcTZDateTimeConverter().fromJson(json['EndTime'] as String?),
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
      'CategoryIds': toSet(instance.categoryIds),
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense],
      'MinimumAmount': instance.minimumAmount,
      'MaximumAmount': instance.maximumAmount,
      'StartTime': const UtcTZDateTimeConverter().toJson(instance.startTime),
      'EndTime': dateTimeToJson(instance.endTime),
    };

TransactionTimingModel _$TransactionTimingModelFromJson(
        Map<String, dynamic> json) =>
    TransactionTimingModel(
      id: (json['Id'] as num).toInt(),
      accountId: (json['AccountId'] as num).toInt(),
      userId: (json['UserId'] as num).toInt(),
      type: $enumDecode(_$TransactionTimingTypeEnumMap, json['Type']),
      offsetDays: (json['OffsetDays'] as num).toInt(),
      nextTime:
          const UtcDateTimeConverter().fromJson(json['NextTime'] as String?),
      updatedAt:
          const UtcDateTimeConverter().fromJson(json['UpdatedAt'] as String?),
      createdAt:
          const UtcDateTimeConverter().fromJson(json['CreatedAt'] as String?),
    );

Map<String, dynamic> _$TransactionTimingModelToJson(
        TransactionTimingModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'AccountId': instance.accountId,
      'UserId': instance.userId,
      'Type': _$TransactionTimingTypeEnumMap[instance.type]!,
      'OffsetDays': instance.offsetDays,
      'NextTime': const UtcDateTimeConverter().toJson(instance.nextTime),
      'UpdatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'CreatedAt': const UtcDateTimeConverter().toJson(instance.createdAt),
    };

const _$TransactionTimingTypeEnumMap = {
  TransactionTimingType.once: 'administrator',
  TransactionTimingType.everyday: 'everyday',
  TransactionTimingType.everyweek: 'everyweek',
  TransactionTimingType.everymonth: 'everymonth',
  TransactionTimingType.lastDayOfMonth: 'lastDayOfMonth',
};
