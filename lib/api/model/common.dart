part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class CommonCaptchaModel {
  @JsonKey(defaultValue: '')
  late String picBase64;
  @JsonKey(defaultValue: '')
  late String captchaId;
  CommonCaptchaModel();
  factory CommonCaptchaModel.fromJson(Map<String, dynamic> json) => _$CommonCaptchaModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommonCaptchaModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)

///日金额统计接口数据模型
@JsonSerializable(fieldRename: FieldRename.pascal)
class DayAmountStatisticApiModel {
  late int amount;

  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  DateTime date;
  DayAmountStatisticApiModel({this.amount = 0, required this.date});

  factory DayAmountStatisticApiModel.fromJson(Map<String, dynamic> json) => _$DayAmountStatisticApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$DayAmountStatisticApiModelToJson(this);
}
