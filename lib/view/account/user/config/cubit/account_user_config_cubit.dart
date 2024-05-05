import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:meta/meta.dart';

part 'account_user_config_state.dart';

class AccountUserConfigCubit extends Cubit<AccountUserConfigState> {
  AccountUserConfigCubit({required this.account}) : super(AccountUserConfigInitial());
  final AccountDetailModel account;
  AccountUserConfigModel? config;
  fetchData() async {
    config = await AccountApi.getAccountUserConfig(accountId: account.id);
    emit(AccountUserConfigLoaded());
  }

  updateFlag({required String flagName, required bool status}) async {
    var config =
        await AccountApi.updateAccountUserConfigFlagStatus(accountId: account.id, flagName: flagName, status: status);
    if (config == null) {
      return;
    }
    this.config = config;
    emit(AccountUserConfigLoaded());
  }
}
