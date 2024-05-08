part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

final class AccountInitial extends AccountState {}

//列表
class AccountListLoaded extends AccountState {
  final List<AccountDetailModel> list;

  AccountListLoaded({required this.list});
}

class CanEditAccountListLoaded extends AccountState {
  final List<AccountDetailModel> list;

  CanEditAccountListLoaded({required this.list});
}

class ShareAccountListLoaded extends AccountState {
  final List<AccountModel> list;

  ShareAccountListLoaded({required this.list});
}

// 账本
class AccountSaveSuccess extends AccountState {
  final AccountDetailModel account;
  AccountSaveSuccess(this.account);
}

class AccountSaveFail extends AccountState {
  final AccountModel account;
  AccountSaveFail(this.account);
}

/// 账本删除后需要更新当前客户端信息 因为删除的可能是当前操作账本
class AccountDeleteSuccess extends AccountState {
  final UserCurrentModel currentInfo;
  AccountDeleteSuccess(this.currentInfo);
}

class AccountDeleteFail extends AccountState {
  final String? msg;
  AccountDeleteFail({this.msg});
}

// 模板账本
final class AccountTemplateListLoaded extends AccountState {
  final List<AccountTemplateModel> list;
  AccountTemplateListLoaded(this.list);
}

final class AccountTransCategoryInitSuccess extends AccountState {
  AccountTransCategoryInitSuccess();
}
