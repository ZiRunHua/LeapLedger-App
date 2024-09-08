part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeFetchDataEvent extends HomeEvent {}

class HomeFetchCategoryAmountRankDataEvent extends HomeEvent {}

class HomeAccountChangeEvent extends HomeEvent {
  final AccountDetailModel account;

  HomeAccountChangeEvent({required this.account});
}

class HomeStatisticUpdateEvent extends HomeEvent {
  final TransactionEditModel? oldTrans;
  final TransactionEditModel? newTrans;
  HomeStatisticUpdateEvent(this.oldTrans, this.newTrans);
}
