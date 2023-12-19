// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonCaptchaModel _$CommonCaptchaModelFromJson(Map<String, dynamic> json) =>
    CommonCaptchaModel()
      ..picBase64 = json['PicBase64'] as String? ?? ''
      ..captchaId = json['CaptchaId'] as String? ?? '';

Map<String, dynamic> _$CommonCaptchaModelToJson(CommonCaptchaModel instance) =>
    <String, dynamic>{
      'PicBase64': instance.picBase64,
      'CaptchaId': instance.captchaId,
    };

AmountCountApiModel _$AmountCountApiModelFromJson(Map<String, dynamic> json) =>
    AmountCountApiModel(
      json['Amount'] as int? ?? 0,
      json['Count'] as int? ?? 0,
    );

Map<String, dynamic> _$AmountCountApiModelToJson(
        AmountCountApiModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Count': instance.count,
    };

IncomeExpenseStatisticApiModel _$IncomeExpenseStatisticApiModelFromJson(
        Map<String, dynamic> json) =>
    IncomeExpenseStatisticApiModel(
      income: json['Income'] == null
          ? null
          : AmountCountApiModel.fromJson(
              json['Income'] as Map<String, dynamic>),
      expense: json['Expense'] == null
          ? null
          : AmountCountApiModel.fromJson(
              json['Expense'] as Map<String, dynamic>),
      startTime: Json.optionDateTimeFromJson(json['StartTime']),
      endTime: Json.optionDateTimeFromJson(json['EndTime']),
    );

Map<String, dynamic> _$IncomeExpenseStatisticApiModelToJson(
        IncomeExpenseStatisticApiModel instance) =>
    <String, dynamic>{
      'Income': instance.income,
      'Expense': instance.expense,
      'StartTime': Json.optionDateTimeToJson(instance.startTime),
      'EndTime': Json.optionDateTimeToJson(instance.endTime),
    };

DayAmountStatisticApiModel _$DayAmountStatisticApiModelFromJson(
        Map<String, dynamic> json) =>
    DayAmountStatisticApiModel(
      amount: json['Amount'] as int? ?? 0,
      date: Json.dateTimeFromJson(json['Date']),
    );

Map<String, dynamic> _$DayAmountStatisticApiModelToJson(
        DayAmountStatisticApiModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Date': Json.dateTimeToJson(instance.date),
    };

UserInfoUpdateModel _$UserInfoUpdateModelFromJson(Map<String, dynamic> json) =>
    UserInfoUpdateModel()..username = json['Username'] as String?;

Map<String, dynamic> _$UserInfoUpdateModelToJson(
        UserInfoUpdateModel instance) =>
    <String, dynamic>{
      'Username': instance.username,
    };

UserHomeApiModel _$UserHomeApiModelFromJson(Map<String, dynamic> json) =>
    UserHomeApiModel()
      ..headerCard = json['HeaderCard'] == null
          ? null
          : UserHomeHeaderCardApiModel.fromJson(
              json['HeaderCard'] as Map<String, dynamic>)
      ..timePeriodStatistics = json['TimePeriodStatistics'] == null
          ? null
          : UserHomeTimePeriodStatisticsApiModel.fromJson(
              json['TimePeriodStatistics'] as Map<String, dynamic>);

Map<String, dynamic> _$UserHomeApiModelToJson(UserHomeApiModel instance) =>
    <String, dynamic>{
      'HeaderCard': instance.headerCard,
      'TimePeriodStatistics': instance.timePeriodStatistics,
    };

UserHomeHeaderCardApiModel _$UserHomeHeaderCardApiModelFromJson(
        Map<String, dynamic> json) =>
    UserHomeHeaderCardApiModel(
      income: json['Income'] == null
          ? null
          : AmountCountApiModel.fromJson(
              json['Income'] as Map<String, dynamic>),
      expense: json['Expense'] == null
          ? null
          : AmountCountApiModel.fromJson(
              json['Expense'] as Map<String, dynamic>),
    )
      ..startTime = Json.optionDateTimeFromJson(json['StartTime'])
      ..endTime = Json.optionDateTimeFromJson(json['EndTime']);

Map<String, dynamic> _$UserHomeHeaderCardApiModelToJson(
        UserHomeHeaderCardApiModel instance) =>
    <String, dynamic>{
      'Income': instance.income,
      'Expense': instance.expense,
      'StartTime': Json.optionDateTimeToJson(instance.startTime),
      'EndTime': Json.optionDateTimeToJson(instance.endTime),
    };

UserHomeTimePeriodStatisticsApiModel
    _$UserHomeTimePeriodStatisticsApiModelFromJson(Map<String, dynamic> json) =>
        UserHomeTimePeriodStatisticsApiModel(
          todayData: IncomeExpenseStatisticApiModel.fromJson(
              json['TodayData'] as Map<String, dynamic>),
          yesterdayData: IncomeExpenseStatisticApiModel.fromJson(
              json['YesterdayData'] as Map<String, dynamic>),
          weekData: IncomeExpenseStatisticApiModel.fromJson(
              json['WeekData'] as Map<String, dynamic>),
          yearData: IncomeExpenseStatisticApiModel.fromJson(
              json['YearData'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$UserHomeTimePeriodStatisticsApiModelToJson(
        UserHomeTimePeriodStatisticsApiModel instance) =>
    <String, dynamic>{
      'TodayData': instance.todayData,
      'YesterdayData': instance.yesterdayData,
      'WeekData': instance.weekData,
      'YearData': instance.yearData,
    };

TransactionQueryConditionApiModel _$TransactionQueryConditionApiModelFromJson(
        Map<String, dynamic> json) =>
    TransactionQueryConditionApiModel(
      accountId: json['AccountId'] as int,
      startTime: Json.dateTimeFromJson(json['StartTime']),
      endTime: Json.dateTimeFromJson(json['EndTime']),
      userIds:
          (json['UserIds'] as List<dynamic>?)?.map((e) => e as int).toSet(),
      categoryIds:
          (json['CategoryIds'] as List<dynamic>?)?.map((e) => e as int).toSet(),
      incomeExpense:
          $enumDecodeNullable(_$IncomeExpenseEnumMap, json['IncomeExpense']),
      minimumAmount: json['MinimumAmount'] as int?,
      maximumAmount: json['MaximumAmount'] as int?,
    );

Map<String, dynamic> _$TransactionQueryConditionApiModelToJson(
        TransactionQueryConditionApiModel instance) =>
    <String, dynamic>{
      'AccountId': instance.accountId,
      'UserIds': instance.userIds?.toList(),
      'CategoryIds': instance.categoryIds?.toList(),
      'IncomeExpense': _$IncomeExpenseEnumMap[instance.incomeExpense],
      'MinimumAmount': instance.minimumAmount,
      'MaximumAmount': instance.maximumAmount,
      'StartTime': Json.dateTimeToJson(instance.startTime),
      'EndTime': Json.dateTimeToJson(instance.endTime),
    };

const _$IncomeExpenseEnumMap = {
  IncomeExpense.income: 'income',
  IncomeExpense.expense: 'expense',
};

TransactionCategoryAmountRankApiModel
    _$TransactionCategoryAmountRankApiModelFromJson(
            Map<String, dynamic> json) =>
        TransactionCategoryAmountRankApiModel(
          amount: json['Amount'] as int? ?? 0,
          count: json['Count'] as int? ?? 0,
          category: TransactionCategoryModel.fromJson(
              json['Category'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$TransactionCategoryAmountRankApiModelToJson(
        TransactionCategoryAmountRankApiModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Count': instance.count,
      'Category': instance.category,
    };
