part of 'edit_bloc.dart';

@immutable
sealed class EditEvent {}

class EditDataFetch extends EditEvent {
  final AccountDetailModel account;
  EditDataFetch(this.account);
}

class TransactionCategoryFetch extends EditEvent {
  final IncomeExpense type;
  TransactionCategoryFetch(this.type);
}

class AccountChange extends EditEvent {
  final AccountDetailModel account;
  AccountChange(this.account);
}

class TransactionSave extends EditEvent {
  final bool isAgain;
  final int? amount;
  TransactionSave(this.isAgain, {this.amount});
}
