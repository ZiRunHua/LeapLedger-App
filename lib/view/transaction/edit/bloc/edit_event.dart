part of 'edit_bloc.dart';

@immutable
sealed class EditEvent {}

class AccountChange extends EditEvent {
  final AccountDetailModel account;
  AccountChange(this.account);
}

class TransactionSave extends EditEvent {
  final bool isAgain;
  final int? amount;
  final IncomeExpense? ie;
  TransactionSave(this.isAgain, {this.amount, this.ie});
}
