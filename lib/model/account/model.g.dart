// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      name: json['Name'] as String? ?? '',
      icon: Json.iconDataFormJson(json['Icon']),
      type: $enumDecodeNullable(_$AccountTypeEnumMap, json['Type'],
              unknownValue: AccountType.independent) ??
          AccountType.independent,
      createTime: Json.dateTimeFromJson(json['CreateTime']),
      updateTime: Json.dateTimeFromJson(json['UpdateTime']),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
      'Type': _$AccountTypeEnumMap[instance.type]!,
      'CreateTime': Json.dateTimeToJson(instance.createTime),
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
    };

const _$AccountTypeEnumMap = {
  AccountType.independent: 'independent',
  AccountType.share: 'share',
};

AccountDetailModel _$AccountDetailModelFromJson(Map<String, dynamic> json) =>
    AccountDetailModel(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      name: json['Name'] as String? ?? '',
      icon: Json.iconDataFormJson(json['Icon']),
      type: $enumDecodeNullable(_$AccountTypeEnumMap, json['Type'],
              unknownValue: AccountType.independent) ??
          AccountType.independent,
      createTime: Json.dateTimeFromJson(json['CreateTime']),
      updateTime: Json.dateTimeFromJson(json['UpdateTime']),
      creatorId: (json['CreatorId'] as num?)?.toInt() ?? 0,
      creatorName: json['CreatorName'] as String? ?? '',
      role: $enumDecodeNullable(_$AccountRoleEnumMap, json['Role'],
              unknownValue: AccountRole.reader) ??
          AccountRole.reader,
      joinTime: Json.dateTimeFromJson(json['JoinTime']),
    );

Map<String, dynamic> _$AccountDetailModelToJson(AccountDetailModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
      'Type': _$AccountTypeEnumMap[instance.type]!,
      'CreateTime': Json.dateTimeToJson(instance.createTime),
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
      'CreatorId': instance.creatorId,
      'CreatorName': instance.creatorName,
      'Role': _$AccountRoleEnumMap[instance.role]!,
      'JoinTime': Json.dateTimeToJson(instance.joinTime),
    };

const _$AccountRoleEnumMap = {
  AccountRole.administrator: 'administrator',
  AccountRole.creator: 'creator',
  AccountRole.ownEditor: 'ownEditor',
  AccountRole.reader: 'reader',
};

AccountUserModel _$AccountUserModelFromJson(Map<String, dynamic> json) =>
    AccountUserModel(
      id: (json['Id'] as num?)?.toInt(),
      accountId: (json['AccountId'] as num).toInt(),
      userId: (json['UserId'] as num).toInt(),
      info: UserInfoModel.fromJson(json['Info'] as Map<String, dynamic>),
      role: $enumDecode(_$AccountRoleEnumMap, json['Role']),
      createTime: Json.dateTimeFromJson(json['CreateTime']),
    );

Map<String, dynamic> _$AccountUserModelToJson(AccountUserModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'AccountId': instance.accountId,
      'Info': instance.info,
      'Role': _$AccountRoleEnumMap[instance.role]!,
      'CreateTime': Json.dateTimeToJson(instance.createTime),
    };

AccountUserInvitationModle _$AccountUserInvitationModleFromJson(
        Map<String, dynamic> json) =>
    AccountUserInvitationModle(
      account: AccountModel.fromJson(json['Account'] as Map<String, dynamic>),
      id: (json['Id'] as num).toInt(),
      invitee: UserInfoModel.fromJson(json['Invitee'] as Map<String, dynamic>),
      inviter: UserInfoModel.fromJson(json['Inviter'] as Map<String, dynamic>),
      role: $enumDecode(_$AccountRoleEnumMap, json['Role']),
      status: $enumDecode(_$AccountUserInvitationStatusEnumMap, json['Status']),
      createTime: Json.dateTimeFromJson(json['CreateTime']),
    );

Map<String, dynamic> _$AccountUserInvitationModleToJson(
        AccountUserInvitationModle instance) =>
    <String, dynamic>{
      'Account': instance.account,
      'Id': instance.id,
      'Invitee': instance.invitee,
      'Inviter': instance.inviter,
      'Role': _$AccountRoleEnumMap[instance.role]!,
      'Status': _$AccountUserInvitationStatusEnumMap[instance.status]!,
      'CreateTime': Json.dateTimeToJson(instance.createTime),
    };

const _$AccountUserInvitationStatusEnumMap = {
  AccountUserInvitationStatus.waiting: 0,
  AccountUserInvitationStatus.accept: 1,
  AccountUserInvitationStatus.refuse: 2,
};

AccountMappingModel _$AccountMappingModelFromJson(Map<String, dynamic> json) =>
    AccountMappingModel(
      id: (json['Id'] as num).toInt(),
      mainAccount:
          AccountModel.fromJson(json['MainAccount'] as Map<String, dynamic>),
      relatedAccount: AccountDetailModel.fromJson(
          json['RelatedAccount'] as Map<String, dynamic>),
      updateTime: Json.dateTimeFromJson(json['UpdateTime']),
      createTime: Json.dateTimeFromJson(json['CreateTime']),
    );

Map<String, dynamic> _$AccountMappingModelToJson(
        AccountMappingModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'MainAccount': instance.mainAccount,
      'RelatedAccount': instance.relatedAccount,
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
      'CreateTime': Json.dateTimeToJson(instance.createTime),
    };

AccountUserConfigModel _$AccountUserConfigModelFromJson(
        Map<String, dynamic> json) =>
    AccountUserConfigModel(
      id: (json['Id'] as num).toInt(),
      userId: (json['UserId'] as num).toInt(),
      accountId: (json['AccountId'] as num).toInt(),
      trans: AccountUserTransConfigModel.fromJson(
          json['Trans'] as Map<String, dynamic>),
      updateTime: Json.dateTimeFromJson(json['UpdateTime']),
      createTime: Json.dateTimeFromJson(json['CreateTime']),
    );

Map<String, dynamic> _$AccountUserConfigModelToJson(
        AccountUserConfigModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'UserId': instance.userId,
      'AccountId': instance.accountId,
      'Trans': instance.trans,
      'UpdateTime': Json.dateTimeToJson(instance.updateTime),
      'CreateTime': Json.dateTimeToJson(instance.createTime),
    };

AccountUserTransConfigModel _$AccountUserTransConfigModelFromJson(
        Map<String, dynamic> json) =>
    AccountUserTransConfigModel(
      syncMappingAccount: json['SyncMappingAccount'] as bool,
    );

Map<String, dynamic> _$AccountUserTransConfigModelToJson(
        AccountUserTransConfigModel instance) =>
    <String, dynamic>{
      'SyncMappingAccount': instance.syncMappingAccount,
    };

AccountTemplateModel _$AccountTemplateModelFromJson(
        Map<String, dynamic> json) =>
    AccountTemplateModel()
      ..id = (json['Id'] as num?)?.toInt() ?? 0
      ..name = json['Name'] as String? ?? ''
      ..icon = Json.iconDataFormJson(json['Icon']);

Map<String, dynamic> _$AccountTemplateModelToJson(
        AccountTemplateModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
    };
