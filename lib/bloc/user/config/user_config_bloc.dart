import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:meta/meta.dart';

part 'user_config_event.dart';
part 'user_config_state.dart';

class UserConfigBloc extends Bloc<UserConfigEvent, UserConfigState> {
  UserConfigBloc() : super(UserConfigInitial()) {
    on<UserTransactionShareConfigFetch>(_getTransShareConfig);
    on<UserTransactionShareConfigUpdate>(_updateTransShareConfig);
  }

  /*交易共享配置 */
  static UserTransactionShareConfigModel? transShareConfig;
  static loadTransShareConfig() async {
    transShareConfig = await UserApi.getTransactionShareConfig();
  }

  _getTransShareConfig(UserTransactionShareConfigFetch event, emit) async {
    await loadTransShareConfig();
    if (transShareConfig == null) {
      return;
    }
    emit(UserTransactionShareConfigLoaded(transShareConfig!));
  }

  _updateTransShareConfig(UserTransactionShareConfigUpdate event, emit) async {
    var data = await UserApi.updateTransactionShareConfig(flag: event.flag, status: event.status);
    if (data == null) {
      return;
    }
    transShareConfig = data;
    emit(UserTransactionShareConfigUpdateSuccess(transShareConfig!));
  }
}
