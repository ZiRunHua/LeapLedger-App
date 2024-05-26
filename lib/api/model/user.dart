part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserInfoUpdateModel {
  late String? username;
  UserInfoUpdateModel();
  factory UserInfoUpdateModel.fromJson(Map<String, dynamic> json) => _$UserInfoUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoUpdateModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)

///首页接口数据模型
class UserHomeApiModel {
  late UserHomeHeaderCardApiModel? headerCard;
  late UserHomeTimePeriodStatisticsApiModel? timePeriodStatistics;
  UserHomeApiModel();
  factory UserHomeApiModel.fromJson(Map<String, dynamic> json) => _$UserHomeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserHomeApiModelToJson(this);
}

///首页头部Card接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class UserHomeHeaderCardApiModel extends InExStatisticWithTimeModel {
  UserHomeHeaderCardApiModel(
      {AmountCountModel? income, AmountCountModel? expense, required super.startTime, required super.endTime})
      : super(income: income, expense: expense);
  int? get days => endTime.difference(startTime).inDays;
  int get dayExpenseAmountaverage {
    if (days == null || expense.amount <= 0) {
      return 0;
    }
    return expense.amount ~/ days!;
  }

  factory UserHomeHeaderCardApiModel.fromJson(Map<String, dynamic> json) => _$UserHomeHeaderCardApiModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserHomeHeaderCardApiModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)

///首页时间段统计接口数据模型
class UserHomeTimePeriodStatisticsApiModel {
  late InExStatisticWithTimeModel todayData;
  late InExStatisticWithTimeModel yesterdayData;
  late InExStatisticWithTimeModel weekData;
  late InExStatisticWithTimeModel yearData;
  UserHomeTimePeriodStatisticsApiModel({
    required this.todayData,
    required this.yesterdayData,
    required this.weekData,
    required this.yearData,
  });
  factory UserHomeTimePeriodStatisticsApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserHomeTimePeriodStatisticsApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserHomeTimePeriodStatisticsApiModelToJson(this);

  bool handleTrans({required TransactionEditModel trans, required bool isAdd}) {
    bool result = false;
    if (todayData.handleTransEditModel(editModel: trans, isAdd: isAdd)) {
      result = true;
    }
    if (yesterdayData.handleTransEditModel(editModel: trans, isAdd: isAdd)) {
      result = true;
    }
    if (weekData.handleTransEditModel(editModel: trans, isAdd: isAdd)) {
      result = true;
    }
    if (yearData.handleTransEditModel(editModel: trans, isAdd: isAdd)) {
      result = true;
    }
    return result;
  }
}
