part of 'account_bloc.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountSaveSuccessState extends AccountState {
  final AccountModel account;
  AccountSaveSuccessState(this.account);
}

class AccountSaveFailState extends AccountState {
  final AccountModel account;
  AccountSaveFailState(this.account);
}

class AccountDeleteSuccessState extends AccountState {}

class AccountDeleteFailState extends AccountState {}
