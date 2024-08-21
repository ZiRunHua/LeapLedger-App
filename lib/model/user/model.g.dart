// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..id = (json['Id'] as num?)?.toInt() ?? 0
  ..username = json['Username'] as String? ?? ''
  ..email = json['Email'] as String? ?? ''
  ..createTime =
      const UtcDateTimeConverter().fromJson(json['CreateTime'] as String?)
  ..updateTime =
      const UtcDateTimeConverter().fromJson(json['UpdateTime'] as String?);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Email': instance.email,
      'CreateTime': const UtcDateTimeConverter().toJson(instance.createTime),
      'UpdateTime': const UtcDateTimeConverter().toJson(instance.updateTime),
    };

UserTransactionShareConfigModel _$UserTransactionShareConfigModelFromJson(
        Map<String, dynamic> json) =>
    UserTransactionShareConfigModel(
      account: json['Account'] as bool,
      createTime: json['CreateTime'] as bool,
      remark: json['Remark'] as bool,
      updateTime: json['UpdateTime'] as bool,
    );

Map<String, dynamic> _$UserTransactionShareConfigModelToJson(
        UserTransactionShareConfigModel instance) =>
    <String, dynamic>{
      'Account': instance.account,
      'CreateTime': instance.createTime,
      'UpdateTime': instance.updateTime,
      'Remark': instance.remark,
    };

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      email: json['Email'] as String,
      id: (json['Id'] as num).toInt(),
      username: json['Username'] as String,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Email': instance.email,
      'Username': instance.username,
    };

UserCurrentModel _$UserCurrentModelFromJson(Map<String, dynamic> json) =>
    UserCurrentModel(
      currentAccount: AccountDetailModel.fromJson(
          json['CurrentAccount'] as Map<String, dynamic>),
      currentShareAccount: AccountDetailModel.fromJson(
          json['CurrentShareAccount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserCurrentModelToJson(UserCurrentModel instance) =>
    <String, dynamic>{
      'CurrentAccount': instance.currentAccount,
      'CurrentShareAccount': instance.currentShareAccount,
    };
