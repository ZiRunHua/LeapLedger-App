import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/account/model.dart';

part 'account_template_list_event.dart';
part 'account_template_list_state.dart';

class AccountTemplateListBloc extends Bloc<AccountTemplateListEvent, AccountTemplateListState> {
  AccountTemplateListBloc() : super(AccountTemplateListInitial()) {
    on<GetListEvent>(_getList);
    on<UseAccountTemplate>(_useAccountTemplate);
  }
  List<AccountTemplateModel> list = [];
  _getList(GetListEvent event, Emitter<AccountTemplateListState> emit) async {
    emit(AccountTemplateListLoading());
    list = await AccountApi.getTemplateList();
    emit(AccountTemplateListLoaded(list));
  }

  _useAccountTemplate(UseAccountTemplate event, Emitter<AccountTemplateListState> emit) async {
    var model = await AccountApi.addAccountByTempalte(event.template);
    emit(AddAccountSuccess(model));
  }
}
