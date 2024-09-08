part of 'model.dart';

enum AccountType {
  @JsonValue("independent")
  independent,
  @JsonValue("share")
  share
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountModel {
  @JsonKey(defaultValue: 0)
  late int id;
  @JsonKey(defaultValue: '')
  late String name;
  @JsonKey(fromJson: Json.iconDataFormJson, toJson: Json.iconDataToJson)
  late IconData icon;
  @JsonKey(defaultValue: AccountType.independent, unknownEnumValue: AccountType.independent)
  late AccountType type;
  @JsonKey(defaultValue: 'Asia/Shanghai', disallowNullValue: true)
  late String location;
  @UtcDateTimeConverter()
  late DateTime createTime;
  @UtcDateTimeConverter()
  late DateTime updateTime;

  bool get isValid => id > 0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final Location timeLocation;
  AccountModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.location,
    required this.createTime,
    required this.updateTime,
  }) {
    timeLocation = getLocation(location.isEmpty ? Constant.defultLocation : location);
  }

  AccountModel.prototypeData(DateTime time)
      : this(
          id: 0,
          name: "test",
          icon: Icons.abc,
          location: Constant.defultLocation,
          type: AccountType.independent,
          createTime: time,
          updateTime: time,
        );

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
  static T fromJsonByType<T extends AccountModel>(Map<String, dynamic> json) {
    switch (T) {
      case AccountDetailModel:
        return AccountDetailModel.fromJson(json) as T;
    }
    return AccountModel.fromJson(json) as T;
  }

  copyWith(AccountModel other) {
    id = other.id;
    name = other.name;
    icon = other.icon;
    type = other.type;
    location = other.location;
    timeLocation = other.timeLocation;
    createTime = other.createTime;
    updateTime = other.updateTime;
  }
}

///账本详情
@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountDetailModel extends AccountModel {
  @JsonKey(defaultValue: 0)
  int creatorId;
  @JsonKey(defaultValue: '')
  String creatorName;
  @JsonKey(defaultValue: AccountRole.reader, unknownEnumValue: AccountRole.reader)
  AccountRole role;
  @UtcDateTimeConverter()
  DateTime joinTime;

  bool get isCreator => role == AccountRole.creator;
  bool get isAdministrator => role == AccountRole.administrator;
  bool get isOwnEditor => role == AccountRole.ownEditor;
  bool get isReader => role == AccountRole.reader;

  bool get isShare => type == AccountType.share;
  bool get canEdit => isCreator;
  AccountDetailModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.type,
    required super.location,
    required super.createTime,
    required super.updateTime,
    required this.creatorId,
    required this.creatorName,
    required this.role,
    required this.joinTime,
  });
  factory AccountDetailModel.fromJson(Map<String, dynamic> json) => _$AccountDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AccountDetailModelToJson(this);

  bool isSame(AccountDetailModel b) {
    return id == b.id &&
        name == b.name &&
        icon == b.icon &&
        type == b.type &&
        createTime == b.createTime &&
        updateTime == b.updateTime &&
        creatorId == b.creatorId &&
        creatorName == b.creatorName &&
        role == b.role &&
        joinTime == b.joinTime;
  }

  AccountDetailModel copy() {
    return AccountDetailModel(
      id: id,
      name: name,
      icon: icon,
      type: type,
      location: location,
      createTime: createTime,
      updateTime: updateTime,
      creatorId: creatorId,
      creatorName: creatorName,
      role: role,
      joinTime: joinTime,
    );
  }

  factory AccountDetailModel.prototypeData() {
    return AccountDetailModel(
      id: 0,
      name: 'prototypeData',
      icon: Icons.account_circle,
      type: AccountType.share,
      location: Constant.defultLocation,
      createTime: DateTime.now(),
      updateTime: DateTime.now(),
      creatorId: 0,
      creatorName: 'prototypeData',
      role: AccountRole.reader,
      joinTime: DateTime.now(),
    );
  }

  TZDateTime getTZDateTime(DateTime time) {
    return TZDateTime.from(time, timeLocation);
  }

  TZDateTime getNowTime() {
    return TZDateTime.now(timeLocation);
  }
}

///账本用户角色
enum AccountRole {
  @JsonValue("administrator")
  administrator(name: '管理员', value: 'administrator'),
  @JsonValue("creator")
  creator(name: '创建者', value: 'creator'),
  @JsonValue("ownEditor")
  ownEditor(name: '普通成员', value: 'ownEditor'),
  @JsonValue("reader")
  reader(name: '只读', value: 'reader');

  const AccountRole({required this.name, required this.value});
  final String name;
  final String value;
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountUserModel {
  late int? id;
  late int userId;
  late int accountId;
  late UserInfoModel info;
  late AccountRole role;
  @UtcDateTimeConverter()
  late DateTime createTime;

  bool get isValid => id != null && id! > 0;

  AccountUserModel({
    this.id,
    required this.accountId,
    required this.userId,
    required this.info,
    required this.role,
    required this.createTime,
  });

  AccountUserModel.formUserInfo({
    required AccountModel account,
    required UserInfoModel user,
  }) : this(
            id: null,
            accountId: account.id,
            userId: user.id,
            info: user,
            role: AccountRole.ownEditor,
            createTime: DateTime.now());

  AccountUserModel copyWith({
    int? accountId,
    int? id,
    int? userId,
    UserInfoModel? info,
    AccountRole? role,
    DateTime? createTime,
  }) =>
      AccountUserModel(
        accountId: accountId ?? this.accountId,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        info: info ?? this.info,
        role: role ?? this.role,
        createTime: createTime ?? this.createTime,
      );
  AccountUserModel.prototypeData()
      : this(
            id: 0,
            accountId: 0,
            userId: 0,
            info: UserInfoModel.prototypeData(),
            role: AccountRole.ownEditor,
            createTime: DateTime.now());
  factory AccountUserModel.fromJson(Map<String, dynamic> json) => _$AccountUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountUserModelToJson(this);
}

enum AccountUserInvitationStatus {
  @JsonValue(0)
  waiting(name: '等待中', value: 0, color: Colors.black87),
  @JsonValue(1)
  accept(name: '接受', value: 1, color: Colors.black87),
  @JsonValue(2)
  refuse(name: '拒绝', value: 2, color: Colors.black87);

  const AccountUserInvitationStatus({required this.name, required this.value, required this.color});
  final String name;
  final int value;
  final Color color;

  static int toInt(AccountUserInvitationStatus value) {
    return value.value;
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountUserInvitationModle {
  AccountModel account;
  int id;
  UserInfoModel invitee;
  UserInfoModel inviter;
  AccountRole role;
  AccountUserInvitationStatus status;
  @UtcDateTimeConverter()
  DateTime createTime;
  AccountUserInvitationModle(
      {required this.account,
      required this.id,
      required this.invitee,
      required this.inviter,
      required this.role,
      required this.status,
      required this.createTime});
  AccountUserInvitationModle.prototypeData(DateTime time)
      : this(
          id: 1,
          account: AccountModel.prototypeData(time),
          invitee: UserInfoModel(email: "testtesttest@qq.com", username: "test", id: 1),
          inviter: UserInfoModel(email: "testtesttest@qq.com", username: "test", id: 1),
          role: AccountRole.ownEditor,
          status: AccountUserInvitationStatus.waiting,
          createTime: time,
        );
  factory AccountUserInvitationModle.fromJson(Map<String, dynamic> json) => _$AccountUserInvitationModleFromJson(json);

  Map<String, dynamic> toJson() => _$AccountUserInvitationModleToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountMappingModel {
  int id;
  AccountModel mainAccount;
  AccountDetailModel relatedAccount;
  @UtcDateTimeConverter()
  DateTime updateTime;
  @UtcDateTimeConverter()
  DateTime createTime;

  AccountMappingModel({
    required this.id,
    required this.mainAccount,
    required this.relatedAccount,
    required this.updateTime,
    required this.createTime,
  });

  factory AccountMappingModel.fromJson(Map<String, dynamic> json) => _$AccountMappingModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountMappingModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountUserConfigModel {
  int id;
  int userId;
  int accountId;
  AccountUserTransConfigModel trans;
  @UtcDateTimeConverter()
  DateTime updateTime;
  @UtcDateTimeConverter()
  DateTime createTime;

  AccountUserConfigModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.trans,
    required this.updateTime,
    required this.createTime,
  });

  AccountUserConfigModel copyWith({
    int? id,
    int? userId,
    int? accountId,
    AccountUserTransConfigModel? trans,
    DateTime? updateTime,
    DateTime? createTime,
  }) =>
      AccountUserConfigModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        accountId: accountId ?? this.accountId,
        trans: trans ?? this.trans,
        updateTime: updateTime ?? this.updateTime,
        createTime: createTime ?? this.createTime,
      );

  factory AccountUserConfigModel.fromJson(Map<String, dynamic> json) => _$AccountUserConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountUserConfigModelToJson(this);

  List<StatusFlagModel> getFlagList() {
    return trans.getFlagList();
  }
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class AccountUserTransConfigModel {
  bool syncMappingAccount;

  AccountUserTransConfigModel({
    required this.syncMappingAccount,
  });

  AccountUserTransConfigModel copyWith({
    bool? syncMappingAccount,
  }) =>
      AccountUserTransConfigModel(
        syncMappingAccount: syncMappingAccount ?? this.syncMappingAccount,
      );

  factory AccountUserTransConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AccountUserTransConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountUserTransConfigModelToJson(this);

  List<StatusFlagModel> getFlagList() {
    return [
      StatusFlagModel(name: "同步至关联账本", flagName: "SyncMappingAccount", status: syncMappingAccount),
    ];
  }
}
