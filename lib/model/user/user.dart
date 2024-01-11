part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: '')
  late String username;
  @JsonKey(defaultValue: '')
  late String email;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime createTime;
  @JsonKey(fromJson: Json.dateTimeFromJson, toJson: Json.dateTimeToJson)
  late DateTime updateTime;
  UserModel();
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)

/// 用户交易分享配置
class UserTransactionShareConfigModel {
  late bool account;
  late bool createTime;
  late bool updateTime;
  late bool remark;

  UserTransactionShareConfigModel({
    required this.account,
    required this.createTime,
    required this.remark,
    required this.updateTime,
  });

  factory UserTransactionShareConfigModel.fromJson(Map<String, dynamic> json) =>
      _$UserTransactionShareConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserTransactionShareConfigModelToJson(this);

  UserTransactionShareConfigModel copyWith({
    bool? account,
    bool? createTime,
    bool? updateTime,
    bool? remark,
  }) =>
      UserTransactionShareConfigModel(
        account: account ?? this.account,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        remark: remark ?? this.remark,
      );
}
