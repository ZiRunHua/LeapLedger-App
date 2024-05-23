part of 'enter.dart';

@immutable
sealed class FlowConditionState {}

final class FlowConditionInitial extends FlowConditionState {}

final class FlowConditionLoading extends FlowConditionState {}

final class FlowConditionLoaded extends FlowConditionState {
  final TransactionQueryCondModel data;
  FlowConditionLoaded(this.data);
}

final class FlowConditionCategoryLoaded extends FlowConditionState {
  FlowConditionCategoryLoaded();
}

final class FlowConditionAccountLoaded extends FlowConditionState {
  final List<AccountDetailModel> data;
  FlowConditionAccountLoaded(this.data);
}

final class FlowEditingConditionUpdate extends FlowConditionState {
  FlowEditingConditionUpdate();
}

final class FlowConditionChanged extends FlowConditionState {
  final TransactionQueryCondModel condition;
  FlowConditionChanged(this.condition);
}

final class FlowCurrentAccountChanged extends FlowConditionState {
  FlowCurrentAccountChanged();
}
