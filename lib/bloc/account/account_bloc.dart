import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/model/account/model.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountListFetchEvent>(_getList);
    on<ShareAccountListFetchEvent>(_getShareAccountList);
    on<AccountSaveEvent>(_handleAccountSave);
    on<AccountDeleteEvent>(_deleteAccount);
    on<AccountTemplateListFetch>(_getTemplateList);
    on<AccountTransCategoryInit>(_useTemplateTransCategory);
  }
  static AccountBloc of(BuildContext context) {
    return BlocProvider.of<AccountBloc>(context);
  }

//列表
  List<AccountModel> _list = [];
  _getList(AccountListFetchEvent event, emit) async {
    if (_list.isEmpty) {
      _list = await AccountApi.getList();
    }
    emit(AccountListLoaded(list: _list));
  }

  _getShareAccountList(ShareAccountListFetchEvent event, emit) async {
    if (_list.isEmpty) {
      _list = await AccountApi.getList();
    }
    List<AccountModel> result = [];
    for (var element in _list) {
      if (element.type == AccountType.share) {
        result.add(element);
      }
    }
    emit(ShareAccountListLoaded(list: result));
  }

// 账本
  _deleteAccount(AccountDeleteEvent event, Emitter<AccountState> emit) async {
    if (event.account.id == UserBloc.currentAccount.id) {
      emit(AccountDeleteFail(msg: "当前账本正在使用"));
      return;
    }
    if ((await AccountApi.delete(event.account.id)).isSuccess) {
      _list.removeWhere((element) => element.id == event.account.id);
      emit(AccountListLoaded(list: _list));
      emit(AccountDeleteSuccess());
    } else {
      emit(AccountDeleteFail());
    }
  }

  _handleAccountSave(AccountSaveEvent event, Emitter<AccountState> emit) async {
    if (event.account.id > 0) {
      // 编辑
      if ((await AccountApi.update(event.account)).isSuccess) {
        int index = _list.indexWhere((element) => element.id == event.account.id);
        _list[index] = event.account;
        emit(AccountListLoaded(list: _list));
        emit(AccountSaveSuccess(event.account));
      } else {
        emit(AccountSaveFail(event.account));
      }
    } else {
      // 新增
      AccountModel? newAccount = await AccountApi.add(event.account);
      if (newAccount == null) {
        emit(AccountSaveFail(event.account));
        return;
      }
      _list.add(newAccount);
      emit(AccountListLoaded(list: _list));
      emit(AccountSaveSuccess(newAccount));
    }
  }

  // 模板账本
  List<AccountTemplateModel> _templateList = [];
  _getTemplateList(AccountTemplateListFetch evnet, emit) async {
    if (_templateList.isEmpty) {
      _templateList = await AccountApi.getTemplateList();
    }
    emit(AccountTemplateListLoaded(_templateList));
  }

  _useTemplateTransCategory(AccountTransCategoryInit event, emit) async {
    var responseData = await AccountApi.initTransCategoryByTempalte(account: event.account, template: event.template);
    if (responseData == null) {
      return;
    }
    emit(AccountTransCategoryInitSuccess());
  }
}
