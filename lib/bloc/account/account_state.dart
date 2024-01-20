part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

final class AccountInitial extends AccountState {}

//列表

class AccountListLoaded extends AccountState {
  final List<AccountModel> list;

  AccountListLoaded({required this.list});
}

class ShareAccountListLoaded extends AccountState {
  final List<AccountModel> list;

  ShareAccountListLoaded({required this.list});
}

// 账本
class AccountSaveSuccess extends AccountState {
  final AccountModel account;
  AccountSaveSuccess(this.account);
}

class AccountSaveFail extends AccountState {
  final AccountModel account;
  AccountSaveFail(this.account);
}

class AccountDeleteSuccess extends AccountState {}

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
