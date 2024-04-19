part of 'edit_bloc.dart';

@immutable
sealed class EditState {}

final class EditInitial extends EditState {}

final class ExpenseCategoryPickLoaded extends EditState {
  final List<TransactionCategoryModel> tree;
  ExpenseCategoryPickLoaded(this.tree);
}

final class IncomeCategoryPickLoaded extends EditState {
  final List<TransactionCategoryModel> tree;
  IncomeCategoryPickLoaded(this.tree);
}

final class AccountChanged extends EditState {
  final AccountDetailModel account;
  AccountChanged(this.account);
}

final class AddNewTransaction extends EditState {
  final TransactionEditModel trans;
  AddNewTransaction(this.trans);
}

final class UpdateTransaction extends EditState {
  final TransactionModel oldTrans;
  final TransactionEditModel editModel;
  UpdateTransaction(this.oldTrans, this.editModel);
}
