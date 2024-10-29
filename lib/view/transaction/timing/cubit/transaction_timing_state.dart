part of 'transaction_timing_cubit.dart';

@immutable
sealed class TransactionTimingState {}

final class TransactionTimingInitial extends TransactionTimingState {}

final class TransactionTimingConfigSaved extends TransactionTimingState {
  final ({TransactionInfoModel trans, TransactionTimingModel config}) record;
  TransactionInfoModel get trans => record.trans;
  TransactionTimingModel get config => record.config;
  TransactionTimingConfigSaved({required this.record});
}

final class TransactionTimingListLoaded extends TransactionTimingState {
  TransactionTimingListLoaded();
}

final class TransactionTimingListLoadingMore extends TransactionTimingListLoaded {
  TransactionTimingListLoadingMore();
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

final class TransactionTimingTransDeleted extends TransactionTimingState {
  final TransactionTimingModel config;
  TransactionTimingTransDeleted({required this.config});
}

final class TransactionTimingTransUpdated extends TransactionTimingState {
  final ({TransactionInfoModel trans, TransactionTimingModel config}) record;
  TransactionInfoModel get trans => record.trans;
  TransactionTimingModel get config => record.config;
  TransactionTimingTransUpdated({required this.record});
}
