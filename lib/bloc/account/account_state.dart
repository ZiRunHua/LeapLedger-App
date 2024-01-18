part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

final class AccountInitial extends AccountState {}

final class AccountTemplateListLoaded extends AccountState {
  final List<AccountTemplateModel> list;
  AccountTemplateListLoaded(this.list);
}

final class AccountTransCategoryInitSuccess extends AccountState {
  AccountTransCategoryInitSuccess();
}

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

class AccountListLoading extends AccountState {}

class AccountListLoaded extends AccountState {
  final List<AccountModel> list;

  AccountListLoaded({required this.list});
}
