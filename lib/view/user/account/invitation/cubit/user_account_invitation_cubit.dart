import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:meta/meta.dart';

part 'user_account_invitation_state.dart';

class UserAccountInvitationCubit extends Cubit<UserAccountInvitationState> {
  UserAccountInvitationCubit() : super(UserAccountInvitationInitial());
  Future<void> fetchData(int limit, int offset) async {
    var list = await UserApi.getAccountInvitation(limit: limit, offset: offset);
    emit(UserAccountInvitationLoaded(list));
  }

  Future<void> accpect(AccountUserInvitationModle model) async {
    var data = await AccountApi.acceptInvitation(model.id);
    if (data == null) {
      return;
    }
    emit(UserAccountInvitationUpdated(data));
  }

  Future<void> refuse(AccountUserInvitationModle model) async {
    var data = await AccountApi.refuseInvitation(model.id);
    if (data == null) {
      return;
    }
    emit(UserAccountInvitationUpdated(data));
  }
}
