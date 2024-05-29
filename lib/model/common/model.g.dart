// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountDateModel _$AmountDateModelFromJson(Map<String, dynamic> json) =>
    AmountDateModel(
      amount: (json['Amount'] as num).toInt(),
      type: $enumDecode(_$DateTypeEnumMap, json['Type']),
      date: Json.dateTimeFromJson(json['Date']),
    );

Map<String, dynamic> _$AmountDateModelToJson(AmountDateModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Date': Json.dateTimeToJson(instance.date),
      'Type': _$DateTypeEnumMap[instance.type]!,
    };

const _$DateTypeEnumMap = {
  DateType.day: 'day',
  DateType.month: 'month',
  DateType.year: 'year',
};

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

AmountCountWithTimeModel _$AmountCountWithTimeModelFromJson(
        Map<String, dynamic> json) =>
    AmountCountWithTimeModel(
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      count: (json['Count'] as num?)?.toInt() ?? 0,
      startTime: Json.dateTimeFromJson(json['StartTime']),
      endTime: Json.dateTimeFromJson(json['EndTime']),
    );

Map<String, dynamic> _$AmountCountWithTimeModelToJson(
        AmountCountWithTimeModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Count': instance.count,
      'StartTime': Json.dateTimeToJson(instance.startTime),
      'EndTime': Json.dateTimeToJson(instance.endTime),
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

InExStatisticWithTimeModel _$InExStatisticWithTimeModelFromJson(
        Map<String, dynamic> json) =>
    InExStatisticWithTimeModel(
      income: json['Income'] == null
          ? null
          : AmountCountModel.fromJson(json['Income'] as Map<String, dynamic>),
      expense: json['Expense'] == null
          ? null
          : AmountCountModel.fromJson(json['Expense'] as Map<String, dynamic>),
      startTime: Json.dateTimeFromJson(json['StartTime']),
      endTime: Json.dateTimeFromJson(json['EndTime']),
    );

Map<String, dynamic> _$InExStatisticWithTimeModelToJson(
        InExStatisticWithTimeModel instance) =>
    <String, dynamic>{
      'Income': instance.income,
      'Expense': instance.expense,
      'StartTime': Json.dateTimeToJson(instance.startTime),
      'EndTime': Json.dateTimeToJson(instance.endTime),
    };
