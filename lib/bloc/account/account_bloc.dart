import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/user/model.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountListFetchEvent>(_getList);
    on<CanEditAccountListFetchEvent>(_getCanEditList);
    on<AccountSaveEvent>(_handleAccountSave);
    on<AccountDeleteEvent>(_deleteAccount);
    on<AccountTemplateListFetch>(_getTemplateList);
    on<AccountTransCategoryInit>(_useTemplateTransCategory);
  }
  static AccountBloc of(BuildContext context) {
    return BlocProvider.of<AccountBloc>(context);
  }

  //列表
  List<AccountDetailModel> _list = [];
  List<AccountDetailModel> get shareList => _list.where((element) => element.type == AccountType.share).toList();
  _getList(AccountListFetchEvent event, emit) async {
    if (_list.isEmpty) {
      _list = await AccountApi.getList();
    }
    emit(AccountListLoaded(list: _list));
  }

  _getCanEditList(CanEditAccountListFetchEvent event, emit) async {
    _list = await AccountApi.getList();
    emit(CanEditAccountListLoaded(list: _list.where((element) => element.role != AccountRole.reader).toList()));
  }

  // 账本
  _deleteAccount(AccountDeleteEvent event, Emitter<AccountState> emit) async {
    var currentInfo = await AccountApi.delete(event.account.id);
    if (currentInfo != null) {
      _list.removeWhere((element) => element.id == event.account.id);
      emit(AccountListLoaded(list: _list));
      emit(AccountDeleteSuccess(currentInfo));
    } else {
      emit(AccountDeleteFail());
    }
  }

  _handleAccountSave(AccountSaveEvent event, Emitter<AccountState> emit) async {
    if (event.account.isValid) {
      // 编辑
      var response = await AccountApi.update(event.account);
      if (response.isSuccess) {
        int index = _list.indexWhere((element) => element.id == event.account.id);
        var newAccount = AccountDetailModel.fromJson(response.data);
        _list[index] = newAccount;
        emit(AccountListLoaded(list: _list));
        emit(AccountSaveSuccess(newAccount));
      } else {
        emit(AccountSaveFail(event.account));
      }
    } else {
      // 新增
      AccountDetailModel? newAccount = await AccountApi.add(event.account);
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
    emit(AccountTransCategoryInitSuccess(responseData));
  }
}
