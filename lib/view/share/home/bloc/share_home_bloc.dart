import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/bloc/transaction/transaction_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';

part 'share_home_event.dart';
part 'share_home_state.dart';

class ShareHomeBloc extends Bloc<ShareHomeEvent, ShareHomeState> {
  ShareHomeBloc({required TransactionBloc transactionBloc}) : super(ShareHomeInitial()) {
    _transBloc = transactionBloc;
    _transBlocSubscription = _transBloc.stream.listen(_transBlocListen);
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
    on<AddRecentTrans>((event, emit) => _addRecentTrans(trans: event.trans, emit));
    on<DeleteRecentTrans>((event, emit) => _deleteRecentTrans(emit, trans: event.trans));
    on<UpdateTotal>((event, emit) => _updateTotal(emit, oldTrans: event.oldTrans, newTrans: event.newTrans));
  }
  static ShareHomeBloc of(BuildContext context) {
    return BlocProvider.of<ShareHomeBloc>(context);
  }

  late final TransactionBloc _transBloc;
  late final StreamSubscription _transBlocSubscription;
  _transBlocListen(TransactionState state) {
    if (account == null) return;
    if (state is TransactionStatisticUpdate) {
      if (account!.id == state.oldTrans?.accountId || account!.id == state.newTrans?.accountId) {
        this.add(UpdateTotal(state.oldTrans, state.newTrans));
      }
      return;
    }
    if (state is! AccountRelatedTransactionState) {
      return;
    }
    var isCurrentAccount = account != null && state.accountId == account!.id;
    if (!isCurrentAccount) {
      return;
    }
    if (state is TransactionAddSuccess) {
      this.add(AddRecentTrans(state.trans));
    } else if (state is TransactionDeleteSuccess) {
      this.add(DeleteRecentTrans(state.delTrans));
    } else if (state is TransactionUpdateSuccess) {
      this.add(DeleteRecentTrans(state.oldTrans));
      this.add(AddRecentTrans(state.newTrans));
    }
  }

  @override
  Future<void> close() async {
    _transBlocSubscription.cancel();
    await super.close();
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
      emit(ShareHomeLoaded());
      await Future.wait([_getRecentTrans(emit), _getAccountUser(emit), _getTotal(emit), _getAccountMapping(emit)]);
    } else {
      emit(ShareHomeLoaded());
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
    emit(ShareHomeLoaded());
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

  InExStatisticWithTimeModel? todayTransTotal, monthTransTotal;
  Future<void> _getTotal(emit) async {
    if (account == null) {
      return;
    }
    var record = await AccountApi.getInfo(
        accountId: account!.id, types: [InfoType.todayTransTotal, InfoType.currentMonthTransTotal]);
    record.todayTransTotal!.setLocation(account!.timeLocation);
    record.currentMonthTransTotal!.setLocation(account!.timeLocation);
    todayTransTotal = record.todayTransTotal;
    monthTransTotal = record.currentMonthTransTotal;
    emit(AccountTotalLoaded(todayTransTotal!, monthTransTotal!));
  }

  Future<void> _updateTotal(emit, {TransactionEditModel? oldTrans, TransactionEditModel? newTrans}) async {
    if (account == null || todayTransTotal == null || monthTransTotal == null) {
      return;
    }
    if (oldTrans != null && oldTrans.accountId == account!.id) {
      oldTrans.setLocation(account!.timeLocation);
      todayTransTotal!.handleTransEditModel(editModel: oldTrans, isAdd: false);
      monthTransTotal!.handleTransEditModel(editModel: oldTrans, isAdd: false);
    }
    if (newTrans != null && newTrans.accountId == account!.id) {
      newTrans.setLocation(account!.timeLocation);
      todayTransTotal!.handleTransEditModel(editModel: newTrans, isAdd: true);
      monthTransTotal!.handleTransEditModel(editModel: newTrans, isAdd: true);
    }
    emit(AccountTotalLoaded(todayTransTotal!, monthTransTotal!));
  }

  List<TransactionModel> recentTrans = [];
  Future<void> _getRecentTrans(emit) async {
    if (account == null) {
      return;
    }
    recentTrans = await AccountApi.getRecentTrans(accountId: account!.id);
    recentTrans.forEach((trans) => trans.setLocation(account!.timeLocation));
    emit(AccountRecentTransLoaded(recentTrans));
  }

  Future<void> _addRecentTrans(emit, {required TransactionModel trans}) async {
    if (account == null || account!.id != trans.accountId) return;
    trans.setLocation(account!.timeLocation);
    var length = recentTrans.length;
    for (int i = 0; i < length; i++) {
      if (recentTrans[i].tradeTime.isBefore(trans.tradeTime)) {
        recentTrans.insert(i, trans);
        break;
      }
    }
    if (length == recentTrans.length) recentTrans.add(trans);
    emit(AccountRecentTransLoaded(recentTrans));
  }

  Future<void> _deleteRecentTrans(emit, {required TransactionModel trans}) async {
    if (account == null || account!.id != trans.accountId) return;
    trans.setLocation(account!.timeLocation);
    var index = recentTrans.indexWhere((element) => trans.id == element.id);
    if (index < 0) return;
    recentTrans.removeAt(index);
    emit(AccountRecentTransLoaded(recentTrans));
  }
}
