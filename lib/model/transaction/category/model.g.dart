// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategoryModel _$TransactionCategoryModelFromJson(
        Map<String, dynamic> json) =>
    TransactionCategoryModel(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String? ?? '',
      icon: Json.iconDataFormJson(json['Icon']),
      fatherId: (json['FatherId'] as num?)?.toInt() ?? 0,
      accountId: (json['AccountId'] as num?)?.toInt() ?? 0,
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.income,
      createdAt: Json.dateTimeFromJson(json['CreatedAt']),
      updatedAt: Json.dateTimeFromJson(json['UpdatedAt']),
    );

Map<String, dynamic> _$TransactionCategoryModelToJson(
        TransactionCategoryModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'FatherId': instance.fatherId,
      'AccountId': instance.accountId,
      'CreatedAt': Json.dateTimeToJson(instance.createdAt),
      'UpdatedAt': Json.dateTimeToJson(instance.updatedAt),
    };

const _$IncomeExpenseEnumMap = {
  IncomeExpense.income: 'income',
  IncomeExpense.expense: 'expense',
};

TransactionCategoryFatherModel _$TransactionCategoryFatherModelFromJson(
        Map<String, dynamic> json) =>
    TransactionCategoryFatherModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      accountId: (json['AccountId'] as num?)?.toInt() ?? 0,
      name: json['Name'] as String? ?? '',
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.income,
      createdAt: Json.dateTimeFromJson(json['CreatedAt']),
      updatedAt: Json.dateTimeFromJson(json['UpdatedAt']),
    );

Map<String, dynamic> _$TransactionCategoryFatherModelToJson(
        TransactionCategoryFatherModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'AccountId': instance.accountId,
      'Name': instance.name,
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'CreatedAt': Json.dateTimeToJson(instance.createdAt),
      'UpdatedAt': Json.dateTimeToJson(instance.updatedAt),
    };
