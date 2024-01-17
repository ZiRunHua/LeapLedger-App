part of 'account_bloc.dart';

@immutable
sealed class AccountEvent {}

class AccountTemplateListFetch extends AccountEvent {}

class AccountTransCategoryInit extends AccountEvent {
  final AccountModel account;
  final AccountTemplateModel template;
  AccountTransCategoryInit(this.account, this.template);
}
