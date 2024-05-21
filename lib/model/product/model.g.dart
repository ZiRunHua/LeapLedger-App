// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel()
  ..uniqueKey = json['UniqueKey'] as String? ?? ''
  ..name = json['Name'] as String? ?? '';

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'UniqueKey': instance.uniqueKey,
      'Name': instance.name,
    };

ProductTransactionCategoryModel _$ProductTransactionCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductTransactionCategoryModel(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String? ?? '',
      icon: Json.iconDataFormJson(json['Icon']),
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']) ??
              IncomeExpense.income,
    )..uniqueKey = json['UniqueKey'] as String? ?? '';

Map<String, dynamic> _$ProductTransactionCategoryModelToJson(
        ProductTransactionCategoryModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense]!,
      'UniqueKey': instance.uniqueKey,
    };

const _$IncomeExpenseEnumMap = {
  IncomeExpense.income: 'income',
  IncomeExpense.expense: 'expense',
};

ProductTransactionCategoryMappingModel
    _$ProductTransactionCategoryMappingModelFromJson(
            Map<String, dynamic> json) =>
        ProductTransactionCategoryMappingModel()
          ..accountId = (json['AccountId'] as num?)?.toInt() ?? 0
          ..ptcId = (json['PtcId'] as num?)?.toInt() ?? 0
          ..categoryId = (json['CategoryId'] as num?)?.toInt() ?? 0
          ..productKey = (json['ProductKey'] as num?)?.toInt() ?? 0
          ..createdAt = Json.dateTimeFromJson(json['CreatedAt'])
          ..updatedAt = Json.dateTimeFromJson(json['UpdatedAt']);

Map<String, dynamic> _$ProductTransactionCategoryMappingModelToJson(
        ProductTransactionCategoryMappingModel instance) =>
    <String, dynamic>{
      'AccountId': instance.accountId,
      'PtcId': instance.ptcId,
      'CategoryId': instance.categoryId,
      'ProductKey': instance.productKey,
      'CreatedAt': Json.dateTimeToJson(instance.createdAt),
      'UpdatedAt': Json.dateTimeToJson(instance.updatedAt),
    };
