part of 'model.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: '')
  late String username;
  @JsonKey(defaultValue: '')
  late String email;
  @UtcDateTimeConverter()
  late DateTime createTime;
  @UtcDateTimeConverter()
  late DateTime updateTime;
  UserModel();

  String get uniqueUsername => username + "#" + id.toString();
  bool get isValid => id > 0;

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

///用户信息
@JsonSerializable(fieldRename: FieldRename.pascal)
class UserInfoModel {
  int id;
  String email;
  String username;

  UserInfoModel({
    required this.email,
    required this.id,
    required this.username,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  UserInfoModel.copy(UserInfoModel other)
      : email = other.email,
        id = other.id,
        username = other.username;

  Widget get avatarPainterWidget => SizedBox(
        width: 50.sp,
        height: 50.sp,
        child: CustomPaint(painter: CommonAvatarPainter(username: username)),
      );

  UserInfoModel.prototypeData() : this(id: 1, email: "test2333333@qq.com", username: "testUser");
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class UserCurrentModel {
  AccountDetailModel currentAccount;
  AccountDetailModel currentShareAccount;

  UserCurrentModel({required this.currentAccount, required this.currentShareAccount});

  factory UserCurrentModel.fromJson(Map<String, dynamic> json) => _$UserCurrentModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserCurrentModelToJson(this);
}
