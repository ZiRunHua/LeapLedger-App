// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..id = json['Id'] as int? ?? 0
  ..username = json['Username'] as String? ?? ''
  ..email = json['Email'] as String? ?? ''
  ..createTime = Json.dateTimeFromJson(json['CreateTime'])
  ..updateTime = Json.dateTimeFromJson(json['UpdateTime']);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'Email': instance.email,
      'CreateTime': Json.dateTimeToJson(instance.createTime),
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
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
      id: json['Id'] as int,
      username: json['Username'] as String,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'Email': instance.email,
      'Id': instance.id,
      'Username': instance.username,
    };
