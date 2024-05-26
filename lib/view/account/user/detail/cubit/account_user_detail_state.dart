part of 'account_user_detail_cubit.dart';

@immutable
sealed class AccountUserDetailState {}

final class AccountUserDetailInitial extends AccountUserDetailState {}

final class AccountUserDetailLoad extends AccountUserDetailState {
  final InExStatisticModel? todayTotal;
  final InExStatisticModel? monthTotal;
  final List<TransactionModel>? recentTrans;
  AccountUserDetailLoad({this.todayTotal, this.monthTotal, this.recentTrans});
}

final class AccountUserDetailUpdate extends AccountUserDetailState {
  AccountUserDetailUpdate();
}
