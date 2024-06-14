// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonCaptchaModel _$CommonCaptchaModelFromJson(Map<String, dynamic> json) => CommonCaptchaModel()
  ..picBase64 = json['PicBase64'] as String? ?? ''
  ..captchaId = json['CaptchaId'] as String? ?? '';

Map<String, dynamic> _$CommonCaptchaModelToJson(CommonCaptchaModel instance) => <String, dynamic>{
      'PicBase64': instance.picBase64,
      'CaptchaId': instance.captchaId,
    };

DayAmountStatisticApiModel _$DayAmountStatisticApiModelFromJson(Map<String, dynamic> json) =>
    DayAmountStatisticApiModel(
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      date: Json.dateTimeFromJson(json['Date']),
    );

Map<String, dynamic> _$DayAmountStatisticApiModelToJson(DayAmountStatisticApiModel instance) => <String, dynamic>{
      'Amount': instance.amount,
      'Date': Json.dateTimeToJson(instance.date),
    };

UserInfoUpdateModel _$UserInfoUpdateModelFromJson(Map<String, dynamic> json) =>
    UserInfoUpdateModel()..username = json['Username'] as String?;

Map<String, dynamic> _$UserInfoUpdateModelToJson(UserInfoUpdateModel instance) => <String, dynamic>{
      'Username': instance.username,
    };

UserHomeApiModel _$UserHomeApiModelFromJson(Map<String, dynamic> json) => UserHomeApiModel()
  ..headerCard = json['HeaderCard'] == null
      ? null
      : InExStatisticWithTimeModel.fromJson(json['HeaderCard'] as Map<String, dynamic>)
  ..timePeriodStatistics = json['TimePeriodStatistics'] == null
      ? null
      : UserHomeTimePeriodStatisticsApiModel.fromJson(json['TimePeriodStatistics'] as Map<String, dynamic>);

Map<String, dynamic> _$UserHomeApiModelToJson(UserHomeApiModel instance) => <String, dynamic>{
      'HeaderCard': instance.headerCard,
      'TimePeriodStatistics': instance.timePeriodStatistics,
    };

InExStatisticWithTimeModel _$InExStatisticWithTimeModelFromJson(Map<String, dynamic> json) =>
    InExStatisticWithTimeModel(
      income: json['Income'] == null ? null : AmountCountModel.fromJson(json['Income'] as Map<String, dynamic>),
      expense: json['Expense'] == null ? null : AmountCountModel.fromJson(json['Expense'] as Map<String, dynamic>),
      startTime: Json.dateTimeFromJson(json['StartTime']),
      endTime: Json.dateTimeFromJson(json['EndTime']),
    );

Map<String, dynamic> _$InExStatisticWithTimeModelToJson(InExStatisticWithTimeModel instance) => <String, dynamic>{
      'Income': instance.income,
      'Expense': instance.expense,
      'StartTime': Json.dateTimeToJson(instance.startTime),
      'EndTime': Json.dateTimeToJson(instance.endTime),
    };

UserHomeTimePeriodStatisticsApiModel _$UserHomeTimePeriodStatisticsApiModelFromJson(Map<String, dynamic> json) =>
    UserHomeTimePeriodStatisticsApiModel(
      todayData: InExStatisticWithTimeModel.fromJson(json['TodayData'] as Map<String, dynamic>),
      yesterdayData: InExStatisticWithTimeModel.fromJson(json['YesterdayData'] as Map<String, dynamic>),
      weekData: InExStatisticWithTimeModel.fromJson(json['WeekData'] as Map<String, dynamic>),
      yearData: InExStatisticWithTimeModel.fromJson(json['YearData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserHomeTimePeriodStatisticsApiModelToJson(UserHomeTimePeriodStatisticsApiModel instance) =>
    <String, dynamic>{
      'TodayData': instance.todayData,
      'YesterdayData': instance.yesterdayData,
      'WeekData': instance.weekData,
      'YearData': instance.yearData,
    };

TransactionCategoryAmountRankApiModel _$TransactionCategoryAmountRankApiModelFromJson(Map<String, dynamic> json) =>
    TransactionCategoryAmountRankApiModel(
      amount: (json['Amount'] as num?)?.toInt() ?? 0,
      count: (json['Count'] as num?)?.toInt() ?? 0,
      category: TransactionCategoryModel.fromJson(json['Category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionCategoryAmountRankApiModelToJson(TransactionCategoryAmountRankApiModel instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'Count': instance.count,
      'Category': instance.category,
    };

TransactionCategoryMappingTreeNodeApiModel _$TransactionCategoryMappingTreeNodeApiModelFromJson(
        Map<String, dynamic> json) =>
    TransactionCategoryMappingTreeNodeApiModel(
      childrenIds: (json['ChildrenIds'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      fatherId: (json['FatherId'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionCategoryMappingTreeNodeApiModelToJson(
        TransactionCategoryMappingTreeNodeApiModel instance) =>
    <String, dynamic>{
      'ChildrenIds': instance.childrenIds,
      'FatherId': instance.fatherId,
    };
