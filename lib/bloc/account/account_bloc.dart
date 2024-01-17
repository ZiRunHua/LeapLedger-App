import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/model/account/model.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountTemplateListFetch>(_getTemplateList);
    on<AccountTransCategoryInit>(_useTemplateTransCategory);
  }
  static AccountBloc of(BuildContext context) {
    return BlocProvider.of<AccountBloc>(context);
  }

  List<AccountTemplateModel> list = [];
  _getTemplateList(AccountTemplateListFetch evnet, emit) async {
    if (list.isEmpty) {
      list = await AccountApi.getTemplateList();
    }
    emit(AccountTemplateListLoaded(list));
  }

  _useTemplateTransCategory(AccountTransCategoryInit event, emit) async {
    await AccountApi.initTransCategoryByTempalte(account: event.account, template: event.template);
    emit(AccountTransCategoryInitSuccess());
  }
}
