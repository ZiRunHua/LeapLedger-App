part of 'account_bloc.dart';

@immutable
sealed class AccountEvent {}

// 列表
class AccountListFetchEvent extends AccountEvent {}

// 账本
class AccountSaveEvent extends AccountEvent {
  final AccountModel account;
  AccountSaveEvent(this.account);
}

class AccountDeleteEvent extends AccountEvent {
  final AccountModel account;
  AccountDeleteEvent(this.account);
}

// 模板账本
class AccountTemplateListFetch extends AccountEvent {}

class AccountTransCategoryInit extends AccountEvent {
  final AccountModel account;
  final AccountTemplateModel template;
  AccountTransCategoryInit(this.account, this.template);
}
