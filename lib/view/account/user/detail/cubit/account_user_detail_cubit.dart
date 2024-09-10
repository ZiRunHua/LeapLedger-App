import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/bloc/common/enter.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:meta/meta.dart';

part 'account_user_detail_state.dart';

class AccountUserDetailCubit extends AccountBasedCubit<AccountUserDetailState> {
  AccountUserDetailCubit(this.accountUser, {required super.account}) : super(AccountUserDetailInitial());
  late AccountUserModel accountUser;
  fetchData() async {
    var record = await AccountApi.getUserInfo(id: accountUser.id!, accountId: accountUser.accountId);
    emit(AccountUserDetailLoad(
      todayTotal: record.todayTransTotal,
      monthTotal: record.currentMonthTransTotal,
      recentTrans: record.recentTrans,
    ));
  }

  changeAccountUser(AccountUserModel accountUser) async {
    if (accountUser.id != this.accountUser.id) {
      await fetchData();
    }
    this.accountUser = accountUser;
    emit(AccountUserDetailUpdate());
    return;
  }
}
