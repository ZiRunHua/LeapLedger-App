import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:meta/meta.dart';

part 'account_user_detail_state.dart';

class AccountUserDetailCubit extends Cubit<AccountUserDetailState> {
  AccountUserDetailCubit(this.account, this.accountUser) : super(AccountUserDetailInitial());
  late AccountDetailModel account;
  late AccountUserModel accountUser;
  fetchData() async {
    var record = await AccountApi.getUserInfo(id: accountUser.id!);
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
