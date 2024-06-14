part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeFetchDataEvent extends HomeEvent {}

class HomeAccountChangeEvent extends HomeEvent {
  final AccountDetailModel account;

  HomeAccountChangeEvent({required this.account});
}

class HomeStatisticUpdateEvent extends HomeEvent {
  final TransactionEditModel? oldTrnas;
  final TransactionEditModel? newTrans;
  HomeStatisticUpdateEvent(this.oldTrnas, this.newTrans);
}
