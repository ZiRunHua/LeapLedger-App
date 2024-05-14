part of 'enter.dart';

@immutable
sealed class FlowConditionState {}

final class FlowConditionInitial extends FlowConditionState {}

final class FlowConditionLoading extends FlowConditionState {}

final class FlowConditionLoaded extends FlowConditionState {
  final TransactionQueryConditionApiModel data;
  FlowConditionLoaded(this.data);
}

final class FlowConditionCategoryLoaded extends FlowConditionState {
  FlowConditionCategoryLoaded();
}

final class FlowConditionAccountLoaded extends FlowConditionState {
  final List<AccountDetailModel> data;
  FlowConditionAccountLoaded(this.data);
}

final class FlowConditionUpdate extends FlowConditionState {
  final TransactionQueryConditionApiModel condition;
  FlowConditionUpdate(this.condition);
}
