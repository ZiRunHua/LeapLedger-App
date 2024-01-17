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
