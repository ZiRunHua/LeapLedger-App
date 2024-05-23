part of 'enter.dart';

@immutable
sealed class FlowListEvent {}

class FlowListDataFetchEvent extends FlowListEvent {
  final TransactionQueryCondModel? condition;
  FlowListDataFetchEvent({this.condition});
}

class FlowListMoreDataFetchEvent extends FlowListEvent {
  FlowListMoreDataFetchEvent();
}

class FlowListUpdateConditionEvent extends FlowListEvent {
  FlowListUpdateConditionEvent();
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
