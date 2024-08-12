part of 'transaction_timing_cubit.dart';

@immutable
sealed class TransactionTimingState {}

abstract class AccountRelatedTransactionTimingState extends TransactionTimingState {
  final int accountId;
  AccountRelatedTransactionTimingState({required this.accountId});
  bool isCurrent(AccountModel account) => accountId == account.id;
}

final class TransactionTimingInitial extends TransactionTimingState {}

final class TransactionTimingConfigSaved extends AccountRelatedTransactionTimingState {
  final ({TransactionInfoModel trans, TransactionTimingModel config}) record;
  TransactionInfoModel get trans => record.trans;
  TransactionTimingModel get config => record.config;
  TransactionTimingConfigSaved({required super.accountId, required this.record});
}

final class TransactionTimingListLoaded extends AccountRelatedTransactionTimingState {
  final List<({TransactionInfoModel trans, TransactionTimingModel config})> list;
  TransactionTimingListLoaded({required this.list, required super.accountId});
}

final class TransactionTimingTypeChanged extends TransactionTimingState {
  final TransactionTimingModel config;
  TransactionTimingTypeChanged(this.config);
}

final class TransactionTimingNextTimeChanged extends TransactionTimingState {
  TransactionTimingNextTimeChanged();
}

final class TransactionTimingTransChanged extends TransactionTimingState {
  TransactionTimingTransChanged();
}
