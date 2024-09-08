import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:meta/meta.dart';

part 'account_mapping_state.dart';

class AccountMappingCubit extends Cubit<AccountMappingState> {
  AccountMappingCubit(this.mainAccount, {this.mapping}) : super(AccountMappingInitial());
  final AccountDetailModel mainAccount;
  AccountMappingModel? mapping;
  List<AccountDetailModel> list = [];
  fetchData() async {
    list = await AccountApi.getListByType<AccountDetailModel>(type: AccountType.independent);
    emit(AccountListLoad());
  }

  bool isCurrentMappingAccount(AccountDetailModel account) {
    return mapping != null && mapping!.relatedAccount.id == account.id;
  }

  changeMapping(AccountDetailModel account) async {
    if (isCurrentMappingAccount(account)) {
      var isSuccess = await AccountApi.deleteMapping(mappingId: mapping!.id, accountId: account.id);
      if (false == isSuccess) {
        return;
      }
      mapping = null;
    } else if (mapping == null) {
      var mapping = await AccountApi.createMapping(mainAccountId: mainAccount.id, relatedAccountId: account.id);
      if (mapping == null) {
        return;
      }
      this.mapping = mapping;
    } else {
      var mapping = await AccountApi.updateMapping(
          mappingId: this.mapping!.id, accountId: account.id, relatedAccountId: account.id);
      if (mapping == null) {
        return;
      }
      this.mapping = mapping;
    }
    emit(AccountMappingChanged());
  }
}
