part of 'account_user_config_cubit.dart';

@immutable
sealed class AccountUserConfigState {}

final class AccountUserConfigInitial extends AccountUserConfigState {}

final class AccountUserConfigLoaded extends AccountUserConfigState {}
