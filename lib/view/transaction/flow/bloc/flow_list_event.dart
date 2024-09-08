part of 'enter.dart';

@immutable
sealed class FlowListEvent {}

class FlowListDataFetchEvent extends FlowListEvent {
  final TransactionQueryCondModel? condition;
  final AccountDetailModel account;
  FlowListDataFetchEvent({this.condition, required this.account});
}

class FlowListMoreDataFetchEvent extends FlowListEvent {
  FlowListMoreDataFetchEvent();
}

class FlowListTransactionAddEvent extends FlowListEvent {
  final TransactionModel trans;
  FlowListTransactionAddEvent(this.trans);
}

class FlowListTransactionUpdateEvent extends FlowListEvent {
  final TransactionModel oldTrans;
  final TransactionModel newTrans;
  FlowListTransactionUpdateEvent(this.oldTrans, this.newTrans);
}

class FlowListTransactionDeleteEvent extends FlowListEvent {
  final TransactionModel trans;
  FlowListTransactionDeleteEvent(this.trans);
}
