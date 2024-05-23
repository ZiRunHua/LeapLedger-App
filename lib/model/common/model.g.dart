// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountCountModel _$AmountCountModelFromJson(Map<String, dynamic> json) =>
    AmountCountModel(
      (json['Amount'] as num?)?.toInt() ?? 0,
      (json['Count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AmountCountModelToJson(AmountCountModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Count': instance.count,
    };

InExStatisticModel _$InExStatisticModelFromJson(Map<String, dynamic> json) =>
    InExStatisticModel(
      income: json['Income'] == null
          ? null
          : AmountCountModel.fromJson(json['Income'] as Map<String, dynamic>),
      expense: json['Expense'] == null
          ? null
          : AmountCountModel.fromJson(json['Expense'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InExStatisticModelToJson(InExStatisticModel instance) =>
    <String, dynamic>{
      'Income': instance.income,
      'Expense': instance.expense,
    };
