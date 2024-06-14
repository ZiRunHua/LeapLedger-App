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
  late InExStatisticWithTimeModel? headerCard;
  late UserHomeTimePeriodStatisticsApiModel? timePeriodStatistics;
  UserHomeApiModel();
  factory UserHomeApiModel.fromJson(Map<String, dynamic> json) => _$UserHomeApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserHomeApiModelToJson(this);
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
