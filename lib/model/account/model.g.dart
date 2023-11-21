// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel()
  ..id = json['Id'] as int? ?? 0
  ..name = json['Name'] as String? ?? ''
  ..icon = Json.iconDataFormJson(json['Icon'])
  ..createdAt = Json.dateTimeFromJson(json['CreatedAt'])
  ..updatedAt = Json.dateTimeFromJson(json['UpdatedAt']);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
      'CreatedAt': Json.dateTimeToJson(instance.createdAt),
      'UpdatedAt': Json.dateTimeToJson(instance.updatedAt),
    };

AccountTemplateModel _$AccountTemplateModelFromJson(Map<String, dynamic> json) => AccountTemplateModel()
  ..id = json['Id'] as int? ?? 0
  ..name = json['Name'] as String? ?? ''
  ..icon = Json.iconDataFormJson(json['Icon']);

Map<String, dynamic> _$AccountTemplateModelToJson(AccountTemplateModel instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Icon': Json.iconDataToJson(instance.icon),
    };
