import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';

part 'share_home_event.dart';
part 'share_home_state.dart';

class ShareHomeBloc extends Bloc<ShareHomeEvent, ShareHomeState> {
  ShareHomeBloc() : super(ShareHomeInitial()) {
    on<LoadShareHomeEvent>((event, emit) async {
      await _handleShareHomeLoaded(emit, account: event.account);
    });
    on<LoadAccountListEvent>((event, emit) async {
      await _handelAccountLoad(emit);
    });
    on<ChangeAccountEvent>((event, emit) async {
      await _changeAccount(event.account, emit);
    });
    on<SetAccountMappingEvent>((event, emit) async {
      await _setAccountMapping(event.mapping, emit);
    });
  }
  static ShareHomeBloc of(BuildContext context) {
    return BlocProvider.of<ShareHomeBloc>(context);
  }

  List<AccountDetailModel> accountList = [];

  static AccountDetailModel? account;
  List<AccountUserModel> userList = [];

  Future<void> _handelAccountLoad(emit) async {
    accountList = await AccountApi.getListByType<AccountDetailModel>(type: AccountType.share);
    // 无账本判断
    if (accountList.isEmpty) {
      account = null;
      emit(NoShareAccount());
      return;
    } else if (account == null || accountList.lastIndexWhere((element) => element.id == account!.id) == -1) {
      //当前账本发生变化
      await _changeAccount(accountList.first, emit);
    }
    // 处理完当前账本再emit账本列表 以免menu无初始值
    emit(AccountListLoaded(accountList));
  }

  _handleShareHomeLoaded(emit, {AccountDetailModel? account}) async {
    if (account != null) {
      ShareHomeBloc.account = account;
    }
    if (ShareHomeBloc.account == null || !ShareHomeBloc.account!.isValid) {
      // 无账本则先获取账本列表
      await _handelAccountLoad(emit);
      if (account == null) {
        return;
      }
      await Future.wait([_getRecentTrans(emit), _getAccountUser(emit), _getTotal(emit), _getAccountMapping(emit)]);
    } else {
      await Future.wait([
        _handelAccountLoad(emit),
        _getRecentTrans(emit),
        _getAccountUser(emit),
        _getTotal(emit),
        _getAccountMapping(emit),
      ]);
    }
  }

  AccountMappingModel? accountMapping;
  Future<void> _getAccountMapping(emit) async {
    if (account == null) {
      return;
    }
    accountMapping = await AccountApi.getMapping(accountId: account!.id);
    emit(AccountMappingLoad(accountMapping));
  }

  Future<void> _setAccountMapping(AccountMappingModel? accountMapping, emit) async {
    this.accountMapping = accountMapping;
    emit(AccountMappingLoad(this.accountMapping));
  }

  Future<void> _changeAccount(AccountDetailModel account, emit) async {
    if (false == account.isValid) {
      emit(NoShareAccount());
      return;
    }
    // id发生变化才继续调用接口
    if (ShareHomeBloc.account != null && account.id == ShareHomeBloc.account!.id) {
      ShareHomeBloc.account = account;
      emit(AccountHaveChanged(account));
      await _handelAccountLoad(emit);
      return;
    }
    ShareHomeBloc.account = account;
    emit(AccountHaveChanged(account));
    await Future.wait([
      _getRecentTrans(emit),
      _getAccountUser(emit),
      _getTotal(emit),
      _getAccountMapping(emit),
      _handelAccountLoad(emit)
    ]);
  }

  Future<void> _getAccountUser(emit) async {
    if (account == null) {
      return;
    }

    emit(AccountUserLoading());
    userList = await AccountApi.getUserList(id: account!.id);
    emit(AccountUserLoaded(userList));
  }

  InExStatisticModel? todayTransTotal, monthTransTotal;
  Future<void> _getTotal(emit) async {
    if (account == null) {
      return;
    }
    var record = await AccountApi.getInfo(
        accountId: account!.id, types: [InfoType.todayTransTotal, InfoType.currentMonthTransTotal]);
    todayTransTotal = record.todayTransTotal;
    monthTransTotal = record.currentMonthTransTotal;
    emit(AccountTotalLoaded(todayTransTotal!, monthTransTotal!));
  }

  List<TransactionModel> recentTrans = [];
  Future<void> _getRecentTrans(emit) async {
    if (account == null) {
      return;
    }
    recentTrans = await AccountApi.getRecentTrans(accountId: account!.id);
    emit(AccountRecentTransLoaded(recentTrans));
  }
}
