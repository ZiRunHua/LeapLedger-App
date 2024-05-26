part of 'share_home_bloc.dart';

@immutable
sealed class ShareHomeState {}

final class ShareHomeInitial extends ShareHomeState {}

/// 无共享账本
final class NoShareAccount extends ShareHomeState {}

/// 账本关联关系加载完成
final class AccountMappingLoad extends ShareHomeState {
  final AccountMappingModel? mapping;
  AccountMappingLoad(this.mapping);
}

/// 账本发生变化
final class AccountHaveChanged extends ShareHomeState {
  final AccountModel account;
  AccountHaveChanged(this.account);
}

/// 账本列表加载完成
final class AccountListLoaded extends ShareHomeState {
  final List<AccountDetailModel> list;
  AccountListLoaded(this.list);
}

/// 账本用户加载中
final class AccountUserLoading extends ShareHomeState {
  AccountUserLoading();
}

/// 账本用户加载完成
final class AccountUserLoaded extends ShareHomeState {
  final List<AccountUserModel> list;
  AccountUserLoaded(this.list);
}

/// 账本统计加载完成
final class AccountTotalLoaded extends ShareHomeState {
  final InExStatisticModel todayTransTotal, monthTransTotal;
  AccountTotalLoaded(this.todayTransTotal, this.monthTransTotal);
}

/// 账本近期交易加载完成
final class AccountRecentTransLoaded extends ShareHomeState {
  final List<TransactionModel> list;
  AccountRecentTransLoaded(this.list);
}
