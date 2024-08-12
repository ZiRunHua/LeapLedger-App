part of 'share_home_bloc.dart';

@immutable
sealed class ShareHomeEvent {}

class LoadAccountListEvent extends ShareHomeEvent {
  LoadAccountListEvent();
}

class LoadShareHomeEvent extends ShareHomeEvent {
  final AccountDetailModel? account;
  LoadShareHomeEvent({this.account});
}

class ChangeAccountEvent extends ShareHomeEvent {
  final AccountDetailModel account;
  ChangeAccountEvent(this.account);
}

class SetAccountMappingEvent extends ShareHomeEvent {
  final AccountMappingModel? mapping;
  SetAccountMappingEvent(this.mapping);
}

class AddRecentTrans extends ShareHomeEvent {
  final TransactionModel trans;
  AddRecentTrans(this.trans);
}

class DeleteRecentTrans extends ShareHomeEvent {
  final TransactionModel trans;
  DeleteRecentTrans(this.trans);
}

class UpdateTotal extends ShareHomeEvent {
  final TransactionEditModel? oldTrans;
  final TransactionEditModel? newTrans;
  UpdateTotal(this.oldTrans, this.newTrans);
}
